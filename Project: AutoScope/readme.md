**Project Description:**
This project involves the design and implementation of a detection system that alerts the user when a specific obstacle is detected. The system allows the user to aim at the target using a joystick, and once the target is detected, the system locks onto it, disables further aiming adjustments, and alerts the user with an audible alarm. The system is designed to simulate an "Aim Assist" mechanism for attacking jets, where the rifle locks onto an enemy target and assists the pilot in maintaining the aim for accurate shooting.


**System Components:**

Two Servo Motors: Control the vertical and horizontal axes for aiming.

Joystick: Allows the user to manually aim the servos.

LCD Display: Shows the current state of the system (e.g., target detected or not).

Touch Sensor: Activates the system when touched.

Buzzer: Alerts the user with an audible alarm when a target is detected.

Infrared Sensor: Detects the presence of the target obstacle.



**Functionality:**

The system is activated when the touch sensor is touched.

The user can aim at the target using the joystick, which controls the two servo motors for vertical and horizontal movement.

When the infrared sensor detects the target, the joystick is disabled, and the buzzer activates to alert the user.

The system remains locked onto the target until the obstacle moves out of the detection range.

The LCD displays the current state of the system, such as whether a target is detected or not.
