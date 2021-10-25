#!/usr/bin/env python3

from __future__ import print_function
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from googleapiclient.http import MediaIoBaseDownload

import click
import re
import io
# import pickle

# current default folder id
# NOTE: Update with folder id
DEFAULT_FID = ''

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/drive.readonly']

class Fid(click.ParamType):
    name = 'folder-id'

    def convert(self, value, param, ctx):
        found = re.match(r'[0-9a-zA-Z_\-]{33}', value)

        if not found:
            self.fail(
                f'{value} is not a 32-character hexadecimal string',
                param,
                ctx,
            )

        return value


def GetDriveItems(service, folder_id):
    # Call the Drive v3 API
    print(folder_id)
    results = service.files().list(
        pageSize=50, # make this an argument
        fields="nextPageToken, files(parents, id, name, mimeType)",
        q=f"'{folder_id}' in parents"
    ).execute()
    return results.get('files', [])


@click.group()
@click.option(
    '--token', '-t',
    default='token.json',
    help="User to token to use Google Drive API",
)
@click.pass_context
def main(ctx, token):
    """
    Application to interface with the Google Drive API (v3)
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.

    if os.path.exists('token.json'):
        filename = os.path.expanduser(token)
        creds = Credentials.from_authorized_user_file(token, SCOPES)
    
    ctx.obj = {
        'token': creds,
    }


text_objects = set(['text/plain', 'text/x-sh']),
def _recurse_download(service, folder_id, directory):

    if not os.path.isdir(directory):
        os.mkdir(directory)

    items = GetDriveItems(service, folder_id)
    if not items:
        return
    else:
        for item in items:
            dest = f"{directory}/{item['name']}"

            if item['mimeType'] == 'application/vnd.google-apps.folder':
                _recurse_download(service, item['id'], dest)

            else:
                if os.path.isfile(dest):
                    print(f"Found {dest}")
                    continue

                request = None

                if item['mimeType'] == 'application/vnd.google-apps.document':
                    request = service.files().export_media(fileId=item['id'], mimeType='text/plain')

                else:
                    request = service.files().get_media(fileId=item['id'])
                
                # NOTE: Could check to see if file exists. Or check timestamp?
                mode = 'w'
                if item['mimeType'] not in text_objects:
                    mode += 'b'    
                fh = io.FileIO(dest, mode)
                print(f" ** {item['name']} **")
                downloader = MediaIoBaseDownload(fh, request)
                done = False
                while done is False:
                    status, done = downloader.next_chunk()
                    print("Download %d%%." % int(status.progress() * 100))

                fh.close()


@main.command()
@click.option(
    '--folder-id', '-fid',
    type=Fid(),
    help="Folder ID",
    default=DEFAULT_FID,
)
@click.option(
    '--destination', '-d',
    type=click.Path(),
    default=f"{os.getcwd()}",
    help="Download diretory."
)
@click.pass_context
def download(ctx, folder_id, destination):
    service = build('drive', 'v3', credentials=ctx.obj['token']) 
    output = os.path.expanduser(destination)
    _recurse_download(service, folder_id, output)


@main.command()
@click.option(
    '--folder-id', '-fid',
    type=Fid(),
    help="Folder ID",
    default=DEFAULT_FID,
)
@click.pass_context
def list(ctx, folder_id):
    """
    List files in Google Drive directory.
    """

    service = build('drive', 'v3', credentials=ctx.obj['token'])
    items = GetDriveItems(service, folder_id)

    if not items:
        print('No files found.')
    else:
        for item in items:
            print(item)
            #print(u'{0} ({1}) {2}'.format(item['name'], item['id'], items['mimeType']))


# For now, just save the token to the current directory.
# A config file could be made that would point to the 
# tokens location.
@main.command()
@click.argument('credentials')
def config(credentials):
    """
    Generated token from credentials.
    """
    creds = None
    # If there are no (valid) credentials available, let the user log in.
    
    # if creds and creds.expired and creds.refresh_token:
    #     creds.refresh(Request())
    # else:
    flow = InstalledAppFlow.from_client_secrets_file(
        credentials, SCOPES)
    creds = flow.run_local_server(port=0)

    # Save the credentials for the next run
    with open('token.json', 'w') as token:
        token.write(creds.to_json())

    # could remove credential file here.
    # for now, do this manually!!
    print(f"Token created, credentials.json can be deleted.")


if __name__ == '__main__':
    main()