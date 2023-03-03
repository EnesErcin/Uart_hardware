# What is UART

=========================================================================

Notorious Universal Aschenous Reciver Transmitter is as you might know a simple digital communication protocol. The mysterious name U*A*R*T* contains most of the key terms first letters to understand its essence.  

The fact that it is aschernous means that there is not a shared clock between devices which communicate. If you are new to the subject you might ask how the rights bits are actually chosen by the other device. Simple answer is that they agree on the clock frequency before hand. Although it is possible to adaptively discover the clock frequency of the device it is not a simple design and not needed for most practices. Each device also has to decide if frame check sequence bits are present or not. Frame check sequence is even or odd parity bits for the UART protocols. It is not a necessity but can be preferred for more reliable data transmission. 

The other letters R and T are stand for receiver and transmitter. It means that there are two communication lines and in fact nothing else. There is one bit receiver and one bit transmission line. The absence of shared clock have already mentioned. 

![alt text][uartpins]

One of the downside of these communication module is that unlike SPI or I2C this module can only enables a communication between two devices. So for each couple of devices that wanted to be connected to a large system you have to use a two UART module for each couple. Although it is simple easy to use and somehow reliable it is certainly not a one for all communication protocol.

It is important to mention that there is an optimizations of the signal capture and transmission for UART devices which often gets lack of attention . The transmission when idle transmit a high signal when transmission start the first bit becomes low. But capturing does not happen immediately. Since frequency of the both devices are matched it is possible to wait with not divided clock signal for half of the baud rate than recognize that value as to be bit transmitted. In some application there are sampling functionality for more reliable transmission. In those cases in the acceptable range of the baud rate there are some samples picked then the most frequent data either one or zero is accepted as true value. ![alt text][baudrate]

——

# What code contains

=========================================================================

This repository is a UART project implemented with hardware description language **verilog** which means that if you have an fpga board available you can compile my code with the rigth software for your specific chip. I can confidently say that this module works as I have tried with my own fpga board and not a single problem have occurred. To save you from trouble I also added a **parametric fifo** as there is often need of some sort of memory to buffer the incoming data. Another reason why you might want to use my module is that it is easy to configure baud rate with just changing the _parameter baud rate_ in top module. I did not seemed necessary to include parity bit check does it is absent. 

About This Repository

=========================================================================

# This repository offers:

+ +Tested and verified with actual hardware Uart module

+ +Includes parametric fifo as a memory buffer

+ +Parametric Baud Rate to easily configure desired rate

+ +Written with hardware description language Verilog which is suitable for every fpga chips

This module does not contain:

- -Even odd parity check bit configuration

- -Sampling process for reliable transmission 

[logo]: https://github.com/EnesErcin/Uart_hardware/blob/main/Document/baudrate.png "baudrate"

[uartpins]: https://github.com/EnesErcin/Uart_hardware/blob/main/Document/uartpins.png "uartpins"