@ https://gist.github.com/mathis-m/facd241fe1f324c7b22338484f60338f
@ @ mmap part taken from by https://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-gpio-mem.html


@ Constants for blink at GPIO 15 - GPIO 17

@ GPFSEL1 [Offset: 0x04] responsible for GPIO Pins 10 to 19
@ GPFSEL2 [Offset: 0x08] responsible for GPIO Pins 20 to 29
@ GPCLR0 [Offset: 0x28] responsible for GPIO Pins 0 to 31
@ GPSET0 [Offest: 0x1C] responsible for GPIO Pins 0 to 31

@ GPIO15 Related
.equ    GPFSEL1_GPIO15, 0x04       @ function register offset for GPIO 15
.equ    GPCLR0_GPIO15, 0x28        @ clear register offset for GPIO 15
.equ    GPSET0_GPIO15, 0x1c        @ set register offset for GPIO 15
.equ    GPFSEL1_GPIO15_MASK, 0b111   @ Mask for fn register
.equ    MAKE_GPIO15_OUTPUT, 0b001      @ use pin for output
.equ    PIN_GPIO15, 15                         @ Used to set PIN 15 high / low


@ GPIO16 Related
.equ    GPFSEL1_GPIO16, 0x04       @ function register offset for GPIO 16
.equ    GPCLR0_GPIO16, 0x28        @ clear register offset for GPIO 16
.equ    GPSET0_GPIO16, 0x1c        @ set register offset for GPIO 16
.equ    GPFSEL1_GPIO16_MASK, 0b111   @ Mask for fn register
.equ    MAKE_GPIO16_OUTPUT, 0b001      @ use pin for output
.equ    PIN_GPIO16, 16                         @ Used to set PIN 16 high / low

@ GPIO17 Related
.equ    GPFSEL1_GPIO17, 0x04       @ function register offset for GPIO 17
.equ    GPCLR0_GPIO17, 0x28        @ clear register offset for GPIO 17
.equ    GPSET0_GPIO17, 0x1c        @ set register offset for GPIO 17
.equ    GPFSEL1_GPIO17_MASK, 0b111   @ Mask for fn register for GPIO 17
.equ    MAKE_GPIO17_OUTPUT, 0b001      @ use pin for output for GPIO 17
.equ    PIN_GPIO17, 17                    @ Used to set GPIO 17 high / low

@ GPIO21 Related
.equ    GPFSEL2_GPIO21, 0x08       @ function register offset for GPIO 21
.equ    GPCLR0_GPIO21, 0x28        @ clear register offset for GPIO 21
.equ    GPSET0_GPIO21, 0x1c        @ set register offset for GPIO 21
.equ    GPFSEL2_GPIO21_MASK, 0b111000   @ Mask for fn register for GPIO 21
.equ    MAKE_GPIO21_OUTPUT, 0b1000      @ use pin for output for GPIO 21
.equ    PIN_GPIO21, 21                    @ Used to set GPIO 21 high / low
      

@ GPIO22 Related
.equ    GPFSEL2_GPIO22, 0x08       @ function register offset for GPIO 22
.equ    GPCLR0_GPIO22, 0x28        @ clear register offset for GPIO 22
.equ    GPSET0_GPIO22, 0x1c        @ set register offset for GPIO 22
.equ    GPFSEL2_GPIO22_MASK, 0b111000   @ Mask for fn register for GPIO 22
.equ    MAKE_GPIO22_OUTPUT, 0b1000      @ use pin for output for GPIO 22
.equ    PIN_GPIO22, 22                    @ Used to set GPIO 22 high / low

@ GPIO23 Related
.equ    GPFSEL2_GPIO23, 0x08       @ function register offset for GPIO 23
.equ    GPCLR0_GPIO23, 0x28        @ clear register offset for GPIO 23
.equ    GPSET0_GPIO23, 0x1c        @ set register offset for GPIO 23
.equ    GPFSEL2_GPIO23_MASK, 0b111000   @ Mask for fn register for GPIO 23
.equ    MAKE_GPIO23_OUTPUT, 0b1000      @ use pin for output for GPIO 23
.equ    PIN_GPIO23, 23                    @ Used to set GPIO 23 high / low

@ Args for mmap
.equ    OFFSET_FILE_DESCRP, 0   @ file descriptor
.equ    mem_fd_open, 3
.equ    BLOCK_SIZE, 4096        @ Raspbian memory page
.equ    ADDRESS_ARG, 3          @ device address

@ Misc
.equ    SLEEP_IN_S, 2            @ sleep 2 second
.equ    SLEEP_IN_SS, 6           @ sleep 6 second
.equ    SLEEP_IN_SSS, 10         @ sleep 10 second


@ The following are defined in /usr/include/asm-generic/mman-common.h:
.equ    MAP_SHARED, 1    @ share changes with other processes
.equ    PROT_RDWR, 0x3   @ PROT_READ(0x1)|PROT_WRITE(0x2)

@ Constant program data
    .section .rodata
device:
    .asciz  "/dev/gpiomem"


@ The program
    .text
    .global main
main:
@ Open /dev/gpiomem for read/write and syncing
    ldr     r1, O_RDWR_O_SYNC   @ flags for accessing device
    ldr     r0, mem_fd          @ address of /dev/gpiomem
    bl      open     
    mov     r4, r0              @ use r4 for file descriptor

@ Map the GPIO registers to a main memory location so we can access them
@ mmap(addr[r0], length[r1], protection[r2], flags[r3], fd[r4])
    str     r4, [sp, #OFFSET_FILE_DESCRP]   @ r4=/dev/gpiomem file descriptor
    mov     r1, #BLOCK_SIZE                 @ r1=get 1 page of memory
    mov     r2, #PROT_RDWR                  @ r2=read/write this memory
    mov     r3, #MAP_SHARED                 @ r3=share with other processes
    mov     r0, #mem_fd_open                @ address of /dev/gpiomem
    ldr     r0, GPIO_BASE                   @ address of GPIO
    str     r0, [sp, #ADDRESS_ARG]          @ r0=location of GPIO
    bl      mmap
    mov     r5, r0           @ save the virtual memory address in r5
    
    
@ Set up the GPIO pin function register in programming memory for GPIO 15
    add     r0, r5, #GPFSEL1_GPIO15            @ calculate address for GPFSEL1 for GPIO 15
    ldr     r2, [r0]                    @ get entire GPFSEL1 register for GPIO 15
    bic     r2, r2, #GPFSEL1_GPIO15_MASK   @ clear pin field for GPIO 15
    orr     r2, r2, #MAKE_GPIO15_OUTPUT    @ enter function code for GPIO 15
    str     r2, [r0]                    @ update register for GPIO 15

@ Set up the GPIO pin function register in programming memory for GPIO 16
    add     r0, r5, #GPFSEL1_GPIO16            @ calculate address for GPFSEL1 for GPIO 16
    ldr     r2, [r0]                    @ get entire GPFSEL1 register for GPIO 16
    bic     r2, r2, #GPFSEL1_GPIO16_MASK   @ clear pin field for GPIO 16
    orr     r2, r2, #MAKE_GPIO16_OUTPUT    @ enter function code for GPIO 16
    str     r2, [r0]                    @ update register for GPIO 16
    
@ Set up the GPIO pin function register in programming memory for GPIO 17
   add     r0, r5, #GPFSEL1_GPIO17            @ calculate address for GPFSEL1 for GPIO 17
   ldr     r2, [r0]                    @ get entire GPFSEL1 register for GPIO 17
   bic     r2, r2, #GPFSEL1_GPIO17_MASK   @ clear pin field for GPIO 17
   orr     r2, r2, #MAKE_GPIO17_OUTPUT    @ enter function code for GPIO 17
   str     r2, [r0]                    @ update register for GPIO 17

@ Set up the GPIO pin function register in programming memory for GPIO 21
    add     r0, r5, #GPFSEL2_GPIO21            @ calculate address for GPFSEL2 for GPIO 21
    ldr     r2, [r0]                    @ get entire GPFSEL2 register for GPIO 21
    bic     r2, r2, #GPFSEL2_GPIO21_MASK   @ clear pin field for GPIO 21
    orr     r2, r2, #MAKE_GPIO21_OUTPUT    @ enter function code for GPIO 21
    str     r2, [r0]                    @ update register for GPIO 21

@ Set up the GPIO pin function register in programming memory for GPIO 22
    add     r0, r5, #GPFSEL2_GPIO22            @ calculate address for GPFSEL2 for GPIO 22
    ldr     r2, [r0]                    @ get entire GPFSEL2 register for GPIO 22
    bic     r2, r2, #GPFSEL2_GPIO22_MASK   @ clear pin field for GPIO 22
    orr     r2, r2, #MAKE_GPIO22_OUTPUT    @ enter function code for GPIO 22
    str     r2, [r0]                    @ update register for GPIO 22
                  
@ Set up the GPIO pin function register in programming memory for GPIO 23
    add     r0, r5, #GPFSEL2_GPIO23            @ calculate address for GPFSEL2 for GPIO 23
    ldr     r2, [r0]                    @ get entire GPFSEL2 register for GPIO 23
    bic     r2, r2, #GPFSEL2_GPIO23_MASK   @ clear pin field for GPIO 23
    orr     r2, r2, #MAKE_GPIO23_OUTPUT    @ enter function code for GPIO 23
    str     r2, [r0]                    @ update register for GPIO 23


@ blinking 
loop:

@ Turn on (RED) GPIO 15 
    add     r0, r5, #GPSET0_GPIO15 @ calc GPSET0 address for GPIO 15
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO15    @ shift bit to pin position for GPIO 15
    str     r2, [r0]        @ update register for GPIO 15
    
@ Turn on (GREEN) GPIO 23
    add     r0, r5, #GPSET0_GPIO23 @ calc GPSET0 address for GPIO 23
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO23    @ shift bit to pin position for GPIO 23
    str     r2, [r0]        @ update register for GPIO 23
    
    mov     r0, #SLEEP_IN_SSS @ wait 10 second
    bl      sleep


    
@ Turn on (YELLOW) GPIO 16
    add     r0, r5, #GPSET0_GPIO16 @ calc GPSET0 address for GPIO 16
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO16    @ shift bit to pin position for GPIO 16
    str     r2, [r0]        @ update register for GPIO 16
    
@ Turn on (YELLOW) GPIO 22
    add     r0, r5, #GPSET0_GPIO22 @ calc GPSET0 address for GPIO 22
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO22    @ shift bit to pin position for GPIO 22
    str     r2, [r0]        @ update register for GPIO 22
      
    mov     r0, #SLEEP_IN_SS @ wait 6 second
    bl      sleep
    

@ Turn off (RED) GPIO 15
    add     r0, r5, #GPCLR0_GPIO15 @ calc GPCLR0 address for GPIO 21
    mov     r2, #1          @ turn off bit
    lsl     r2, r2, #PIN_GPIO15    @ shift bit to pin position for GPIO 21
    str     r2, [r0]        @ update register for GPIO 21
 
@ Turn on (GREEN) GPIO 23
    add     r0, r5, #GPSET0_GPIO23 @ calc GPSET0 address for GPIO 23
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO23    @ shift bit to pin position for GPIO 23
    str     r2, [r0]        @ update register for GPIO 23 

@ Turn off (YELLOW) GPIO 16
    add     r0, r5, #GPCLR0_GPIO16 @ calc GPCLR0 address for GPIO 22
    mov     r2, #1          @ turn off bit
    lsl     r2, r2, #PIN_GPIO16    @ shift bit to pin position for GPIO 22
    str     r2, [r0]        @ update register for GPIO 22
    
@ Turn off (YELLOW) GPIO 22
    add     r0, r5, #GPCLR0_GPIO22 @ calc GPCLR0 address for GPIO 22
    mov     r2, #1          @ turn off bit
    lsl     r2, r2, #PIN_GPIO22    @ shift bit to pin position for GPIO 22
    str     r2, [r0]        @ update register for GPIO 22    
  
@ Turn off (GREEN) GPIO 23
    add     r0, r5, #GPCLR0_GPIO23 @ calc GPCLR0 address for GPIO 23
    mov     r2, #1          @ turn off bit
    lsl     r2, r2, #PIN_GPIO23    @ shift bit to pin position for GPIO 23
    str     r2, [r0]        @ update register for GPIO 23
    
@ Turn on (GREEN) GPIO 17
    add     r0, r5, #GPSET0_GPIO17 @ calc GPSET0 address for GPIO 23
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO17    @ shift bit to pin position for GPIO 23
    str     r2, [r0]        @ update register for GPIO 23
    
@ Turn on (RED) GPIO 21 
    add     r0, r5, #GPSET0_GPIO21 @ calc GPSET0 address for GPIO 21
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO21    @ shift bit to pin position for GPIO 21
    str     r2, [r0]        @ update register for GPIO 21    

    mov     r0, #SLEEP_IN_SSS @ wait 10 second
    bl      sleep
    
    
@ Turn off (GREEN) GPIO 17
   add     r0, r5, #GPCLR0_GPIO17 @ calc GPCLR0 address for GPIO 23
   mov     r2, #1          @ turn off bit
   lsl     r2, r2, #PIN_GPIO17    @ shift bit to pin position for GPIO 23
   str     r2, [r0]        @ update register for GPIO 23
   
@ Turn off (RED) GPIO 21
    add     r0, r5, #GPCLR0_GPIO21 @ calc GPCLR0 address for GPIO 21
    mov     r2, #1          @ turn off bit
    lsl     r2, r2, #PIN_GPIO21    @ shift bit to pin position for GPIO 21
    str     r2, [r0]        @ update register for GPIO 21

@ Turn on (YELLOW) GPIO 16
   add     r0, r5, #GPSET0_GPIO16 @ calc GPSET0 address for GPIO 22
    mov     r2, #1          @ turn on bit
    lsl     r2, r2, #PIN_GPIO16    @ shift bit to pin position for GPIO 22
    str     r2, [r0]        @ update register for GPIO 22
    
@ Turn on (YELLOW) GPIO 22
    add     r0, r5, #GPSET0_GPIO22 
    mov     r2, #1          
    lsl     r2, r2, #PIN_GPIO22    
    str     r2, [r0]      
    
   mov     r0, #SLEEP_IN_SS @ wait 6 second
   bl      sleep


@ Turn off (YELLOW) GPIO 16
   add     r0, r5, #GPCLR0_GPIO16 @ calc GPCLR0 address for GPIO 22
    mov     r2, #1          @ turn off bit
    lsl     r2, r2, #PIN_GPIO16    @ shift bit to pin position for GPIO 22
    str     r2, [r0]        @ update register for GPIO 22
    
@Turn off (YELLOW) GPIO 22
   add     r0, r5, #GPCLR0_GPIO22
   mov     r2, #1          
   lsl     r2, r2, #PIN_GPIO22    
   str     r2, [r0]         
    
   mov     r0, #SLEEP_IN_S @ wait 2 second
   bl      sleep
   
    
    b       loop
    
    

GPIO_BASE:
    .word   0xfe200000  @GPIO Base address Raspberry pi 4
mem_fd:
    .word   device
O_RDWR_O_SYNC:
    .word   2|256       @ O_RDWR (2)|O_SYNC (256).


