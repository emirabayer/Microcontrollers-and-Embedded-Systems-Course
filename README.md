# Microcontrollers-and-Embedded-Systems-Course
This repository contains the lab and project codes for the Microcontrollers and Embedded Systems course at Bilkent.

***course link:*** https://catalog.bilkent.edu.tr/course/c14212.html

<br>


<br>

## Personal Course Project - AutoScope
This project involves the design and implementation of a detection system based on FRDM-KL25Z (ARM Cortex-M0+) that alerts the user when a specific obstacle is detected. The system allows the user to aim at the target using a joystick, and once the target is detected, the system locks onto it, disables further aiming adjustments, and alerts the user with an audible alarm. The system is designed to simulate an "Aim Assist" mechanism for attacking jets, where the rifle locks onto an enemy target and assists the pilot in maintaining the aim for accurate shooting.
<br>
<br>

## Lab 1 - Base Conversion and Fibonacci Computation on 8051 Microcontroller
This lab involves programming an 8051 microcontroller to perform base conversions and Fibonacci sequence calculations using the Proteus simulator. The first part implements a decimal-to-binary, base-4, and base-8 converter, displaying results on an LCD. The second part calculates the nth Fibonacci number (0 ≤ n ≤ 24) recursively without lookup tables, handling multi-register storage for larger values. The project demonstrates proficiency in embedded systems programming, microcontroller arithmetic, and LCD interfacing, reinforcing low-level programming and register management skills.
<br>
<br>

## Lab 2: - Square Wave Generation and Dynamic Duty Cycle Control
This lab focuses on generating square waveforms using microcontroller timers. In Part 1, a primary waveform is produced with a specified duty cycle and frequency, while a secondary waveform maintains half the duty cycle. In Part 2, the system dynamically alternates duty cycles at fixed intervals, displaying frequency and duty cycle values on an LCD. The experiment reinforces precise timer usage, waveform control, and real-time display integration. A below 1% error rate was achieved without using interrupts.
<br>
<br>

## Lab 3 - Ping-Pong LED Game on FRDM-KL25Z Board
This lab involves implementing a ping-pong style LED game on the FRDM-KL25Z board, controlling five LEDs with three buttons to create dynamic lighting effects. The project includes a single-ball mode with a bouncing LED pattern, speed toggling (1000 ms to 500 ms), direction reversal, and a two-ball mode with adjacent LED pairs, all managed through GPIO configurations without timers. The implementation showcases proficiency in embedded systems programming, real-time input handling, and state management, demonstrating a strong understanding of hardware interfacing and efficient code design.
<br>
<br>

## Lab 4 - PWM Signal Generation and Servo Motor Control
This lab involves generating PWM signals using FRDM-KL25 timers to control an SG90 servo motor. Students will create PWM signals with specific duty cycles and frequencies, verified using an oscilloscope. The servo motor will rotate in a predefined pattern (0° to 90° and back), and an interrupt service routine (ISR) will toggle the pattern (180° to 90° and back) when a button is pressed. Timers and GPIO configurations are used for PWM generation and motor control.
<br>
<br>
