import statistics as st
def get_args(): #defines all the independent variables
	import argparse
	parser = argparse.ArgumentParser(description = "still need description")
	#parser.add_argument('- command line variable', '-- python variable', description)
	parser.add_argument('-o', '--outdir', help='file to output data')
	return parser.parse_args()
args=get_args()

control_dict={
	#chromosome:(average_tad_size, number of tads)
}
treatment_dict={
	#chromosome:(average_tad_size, number of tads)
}

chromosomes=[]


############## getting stuff from control TADs ###################
control_sizes=[]
control_numbers=[]
tad_sizes=[]

control_boundaries={
	#chromosome:boundary pair
}
prev_chrom='1'
with open(args.outdir+'/control_domains.bed') as control:
	while True:
		line=control.readline().strip().split('\t')

		if line ==['']:
			avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			control_sizes.append(avg_tad_size)
			control_numbers.append(number_tads)
			chromosomes.append(prev_chrom)
			break

		chromosome=line[0]
		tad_start = int(line[1])
		tad_end = int(line[2])
		size_of_tad = tad_end - tad_start
		tad_sizes.append(size_of_tad)

		if chromosome in control_boundaries:
			control_boundaries[chromosome].append((tad_start,tad_end))
		else:
			control_boundaries[chromosome]=[]
			control_boundaries[chromosome].append((tad_start,tad_end))

		if chromosome != prev_chrom:
			avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			control_sizes.append(avg_tad_size)
			control_numbers.append(number_tads)
			chromosomes.append(prev_chrom)
			# control_dict[prev_chrom]=(avg_tad_size,number_tads)
			tad_sizes.clear()

		prev_chrom=chromosome


############ Getting stuff from treatment TADs ############
treatment_boundaries={
	#chromosome:boundary pair
}
treatment_sizes=[]
treatment_numbers=[]
tad_sizes=[]
prev_chrom='1'
with open(args.outdir+'/treatment_domains.bed') as treatment:
	while True:
		line=treatment.readline().strip().split('\t')

		if line ==['']:
			avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			treatment_sizes.append(avg_tad_size)
			treatment_numbers.append(number_tads)
			break
		
		chromosome=line[0]
		tad_start = int(line[1])
		tad_end = int(line[2])
		size_of_tad = tad_end - tad_start
		tad_sizes.append(size_of_tad)

		if chromosome in treatment_boundaries:
			treatment_boundaries[chromosome].append((tad_start,tad_end))
		else:
			treatment_boundaries[chromosome]=[]
			treatment_boundaries[chromosome].append((tad_start,tad_end))

		if chromosome != prev_chrom:
			avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			treatment_sizes.append(avg_tad_size)
			treatment_numbers.append(number_tads)
			# control_dict[prev_chrom]=(avg_tad_size,number_tads)
			tad_sizes.clear()

		prev_chrom=chromosome



############ find different boundaries ##############
same_boundaries=[]
different_boundaries=[]
total_same=0
total_different=0
for chromosome in chromosomes:
	same=0
	different=0
	

	for pair in control_boundaries[chromosome]:
		if (pair in control_boundaries[chromosome]) and (pair in treatment_boundaries[chromosome]):
			same+=1
		else:
			different+=1

	for pair in treatment_boundaries[chromosome]:
		if (pair in control_boundaries[chromosome]) and (pair in treatment_boundaries[chromosome]):
			pass
		else:
			different+=1
			
	same_boundaries.append(same)
	different_boundaries.append(different)
	total_same+=same
	total_different+=different

print('total same boundaries is {}'.format(total_same))
print('total different boundaries is {}'.format(total_different))

boundary_ratio=[] #different:same
for i in range(0,len(chromosomes)):
	boundary_ratio.append(different_boundaries[i]/same_boundaries[i])



################# Getting stuff from accepted TADs ##############
# accepted_sizes=[]
accepted_numbers=[]
tad_sizes=[]
prev_chrom='1'
with open(args.outdir+'/differential_TAD_accepted.bed') as accepted:

	for i in range(0,4): #skips header
		line=accepted.readline().strip().split('\t')

	while True:
		line=accepted.readline().strip().split('\t')
		
		if line ==['']:
			# avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			# accepted_sizes.append(avg_tad_size)
			accepted_numbers.append(number_tads)
			break
		
		chromosome=line[0]
		tad_start = int(line[1])
		tad_end = int(line[2])
		size_of_tad = tad_end - tad_start
		tad_sizes.append(size_of_tad)

		if chromosome != prev_chrom:
			# avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			# accepted_sizes.append(avg_tad_size)
			accepted_numbers.append(number_tads)
			# control_dict[prev_chrom]=(avg_tad_size,number_tads)
			tad_sizes.clear()

		prev_chrom=chromosome

################# Getting stuff from rejected TADs ##############
# rejected_sizes=[]
rejected_numbers=[]
tad_sizes=[]
prev_chrom='1'
with open(args.outdir+'/differential_TAD_rejected.bed') as rejected:
	
	for i in range(0,4): #skips header
		line=rejected.readline().strip().split('\t')

	while True:
		line=rejected.readline().strip().split('\t')
		
		if line ==['']:
			# avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			# rejected_sizes.append(avg_tad_size)
			rejected_numbers.append(number_tads)
			break
		
		chromosome=line[0]
		tad_start = int(line[1])
		tad_end = int(line[2])
		size_of_tad = tad_end - tad_start
		tad_sizes.append(size_of_tad)

		if chromosome != prev_chrom:
			# avg_tad_size=round(st.mean(tad_sizes),0)
			number_tads=len(tad_sizes)
			# rejected_sizes.append(avg_tad_size)
			rejected_numbers.append(number_tads)
			# control_dict[prev_chrom]=(avg_tad_size,number_tads)
			tad_sizes.clear()

		prev_chrom=chromosome


diff_ratios=[]
for i in range(0,len(chromosomes)):
	diff_ratios.append(rejected_numbers[i]/accepted_numbers[i])



################# finding tad boundaries ###################



######### plotting tad sizes  #########
import numpy as np
import matplotlib.pyplot as plt
 
# set width of bar
barWidth = 0.35
fig = plt.subplots(figsize =(12, 8))
 
# Set position of bar on X axis
br1 = np.arange(len(chromosomes))
br2 = [x + barWidth for x in br1]
 
# Make the plot
plt.bar(br1, control_sizes, color ='gold', width = barWidth,
        edgecolor ='black', label ='Primary')
plt.bar(br2, treatment_sizes, color ='darkorchid', width = barWidth,
        edgecolor ='black', label ='Metastasis')
 
# Adding Xticks
plt.xlabel('Chromosome', fontweight ='bold', fontsize = 15)
plt.ylabel('Average Size of TAD', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(chromosomes))],
        chromosomes)
 
plt.legend()
plt.savefig('tad_sizes.png')

#################### plotting tad numbers #####################

# set width of bar
barWidth = 0.35
fig = plt.subplots(figsize =(12, 8))
 
# Set position of bar on X axis
br1 = np.arange(len(chromosomes))
br2 = [x + barWidth for x in br1]
 
# Make the plot
plt.bar(br1, control_numbers, color ='gold', width = barWidth,
        edgecolor ='black', label ='Primary')
plt.bar(br2, treatment_numbers, color ='darkorchid', width = barWidth,
        edgecolor ='black', label ='Metastasis')
 
# Adding Xticks
plt.xlabel('Chromosome', fontweight ='bold', fontsize = 15)
plt.ylabel('Number of TADs', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(chromosomes))],
        chromosomes)
 
plt.legend()
plt.savefig('tad_numbers.png')



# #################### plotting accepted/rejected numbers #####################

# # set width of bar
# barWidth = 0.35
# fig = plt.subplots(figsize =(12, 8))
 
# # Set position of bar on X axis
# br1 = np.arange(len(chromosomes))
# br2 = [x + barWidth for x in br1]
 
# # Make the plot
# plt.bar(br1, accepted_numbers, color ='gold', width = barWidth,
#         edgecolor ='black', label ='Accepted')
# plt.bar(br2, rejected_numbers, color ='darkorchid', width = barWidth,
#         edgecolor ='black', label ='Rejected')
 
# # Adding Xticks
# plt.xlabel('Chromosome', fontweight ='bold', fontsize = 15)
# plt.ylabel('Number of TADs', fontweight ='bold', fontsize = 15)
# plt.xticks([r + barWidth for r in range(len(chromosomes))],
#         chromosomes)
 
# plt.legend()
# plt.savefig('differential_numbers.png')


#################### plotting ratio rejected/accepted numbers #####################

# set width of bar
barWidth = 0.35
fig = plt.subplots(figsize =(12, 8))
 
# Set position of bar on X axis
br1 = np.arange(len(chromosomes))
 
# Make the plot
plt.bar(br1, diff_ratios, color ='b', width = barWidth,
        edgecolor ='black')

 
# Adding Xticks
plt.xlabel('Chromosome', fontweight ='bold', fontsize = 15)
plt.ylabel('Ratio Different/Same TADs', fontweight ='bold', fontsize = 15)
plt.xticks([r for r in range(len(chromosomes))],
        chromosomes)

plt.savefig('differential_numbers.png')


#################### plotting boundary differences #####################

# set width of bar
barWidth = 0.35
fig = plt.subplots(figsize =(12, 8))
 
# Set position of bar on X axis
br1 = np.arange(len(chromosomes))
 
# Make the plot
plt.bar(br1, boundary_ratio, color ='orange', width = barWidth,
        edgecolor ='black')

 
# Adding Xticks
plt.xlabel('Chromosome', fontweight ='bold', fontsize = 15)
plt.ylabel('Ratio different/same boundaries', fontweight ='bold', fontsize = 15)
plt.xticks([r for r in range(len(chromosomes))],
        chromosomes)

plt.savefig('differential_boundaries.png')
