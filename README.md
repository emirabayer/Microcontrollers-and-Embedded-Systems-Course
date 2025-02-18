# Microcontrollers-and-Embedded-Systems-Course
This repository contains the lab and project codes for the Microcontrollers and Embedded Systems course at Bilkent.

***course link:*** https://catalog.bilkent.edu.tr/course/c14212.html

<br>


<br>

## Personal Course Project - AutoScope
This project involves the design and implementation of a detection system that alerts the user when a specific obstacle is detected. The system allows the user to aim at the target using a joystick, and once the target is detected, the system locks onto it, disables further aiming adjustments, and alerts the user with an audible alarm. The system is designed to simulate an "Aim Assist" mechanism for attacking jets, where the rifle locks onto an enemy target and assists the pilot in maintaining the aim for accurate shooting.
<br>
<br>

## Lab 1 - Hexadecimal Digit Sum and Day-of-Year Calculation
This lab has two parts. In Part 1, students write a program to convert a hexadecimal number to decimal and sum its digits, showing results on the MCU 8051 IDE simulator. In Part 2, students determine the month, day, and weekday for a given day-of-year input (1-366) using Proteus, displaying results on an LCD. Both parts emphasize simulation and correct output display.
<br>
<br>

## Lab 2: - Timer-Based Waveform Generation and Countdown System
This lab focuses on using 8051 microcontroller timers. In Part 1, students generate two square waveforms with specific frequencies and duty cycles based on a switch configuration, displaying results on a Proteus oscilloscope. In Part 2, a countdown system is implemented, taking input from a keypad and displaying the countdown on an LCD, updating every 0.5 seconds. Both parts emphasize precision and correct use of timers.
<br>
<br>

## Lab 3 - 4-Bit Binary Counter with Adjustable Rate and Direction
This lab involves implementing a 4-bit binary counter using switches to control counting rate and direction. Switches adjust the counting rate (0ms, 250ms, 500ms, 1000ms) and toggle between increasing and decreasing order. LEDs represent the 4-bit counter. Students must ensure real-time switch configuration changes without resetting the counter, using a custom delay function instead of timers. Partial credit is available for incomplete implementations.
<br>
<br>

## Lab 4 - PWM Signal Generation and Servo Motor Control
This lab involves generating PWM signals using FRDM-KL25 timers to control an SG90 servo motor. Students will create PWM signals with specific duty cycles and frequencies, verified using an oscilloscope. The servo motor will rotate in a predefined pattern (0° to 90° and back), and an interrupt service routine (ISR) will toggle the pattern (180° to 90° and back) when a button is pressed. Timers and GPIO configurations are used for PWM generation and motor control.
<br>
<br>
