��# ! / u s r / b i n / b a s h  
 # t h i s   s c r i p t   a s s u m e s   i n p u t   h i c   f i l e s   h a v e   f o r m a t   < n a m e > . h i c  
  
 d a t a _ d i r = < p a t h   t o   . h i c   f i l e s >   # s h o u l d   c h a n g e   t o   r e l a t i v e   t o   p a t h s  
 o u t _ d i r = < p a t h   t o   o u t p u t   c o o l   f i l e s >  
 r e s = 5 0 0 0 0   # d e s i r e d   r e s o l u t i o n   o f   r e s u l t i n g   c o o l   f i l e s  
  
 m k d i r   $ o u t _ d i r   # s h o u l d   c h a n g e   t o   r e l a t i v e   t o   p a t h s  
  
 l s   - 1   $ d a t a _ d i r   | g r e p   ' . h i c '   | w h i l e   r e a d   f i l e ;  
 d o   \  
 h i c C o n v e r t F o r m a t   \  
 - - m a t r i c e s   $ d a t a _ d i r / $ f i l e   \  
 - - i n p u t F o r m a t   h i c   \  
 - - o u t F i l e N a m e   $ o u t _ d i r / $ ( e c h o   $ f i l e   |   c u t   - f 1   - d . ) _ r e s o l u t i o n . c o o l   \  
 - - o u t p u t F o r m a t   c o o l   \  
 - - r e s o l u t i o n s   $ r e s ;  
 d o n e 
