# ECE 4950 Project 1
Setting Up a Device to Receive and Transmit Data
Introduction to Additive Manufacturing / Rapid Prototyping

Goals
1. Become familiar with the ECE 4950 laboratory including software, room access, and equipment.
2. Investigate the MATLAB/Simulink real-time software and Arduino for future use.
3. Appreciate the 3D Printer as a rapid-prototyping tool for mechanical parts. Learn to rudimentarily use
3D modeling software.
4. Develop structure and working relationships within the project group.

# Project Overview
1. Each group will test their system by interfacing a sensor and actuator. The system developed by
the teams will use a potentiometer to trigger a servomotor. The threshold for the sensor will have to
be variable to allow for changes upon request by the user. Note that you may not be able to connect
the servo directly to the Arduino. You will have to research safe interfacing of the servo to the
Arduino and report on your findings and method along with any design considerations and
component choices.
2. Each group will design and fabricate a small object that can be printed on a 3D Printer. You
will have to design a small 4”x2”x1”(LxWxH) part. It should have the team number
embossed/debossed on it. You do not have to 3D print the design.
Configuring the Software
Each group will configure a student-supplied laptop to work as the Host on which the software will be
installed. This includes the C++ suite including runtime libraries and Matlab 2021b or later. Make sure
you copy the installation files from the network drive before installing; This will significantly reduce your
installation time. Additional libraries for Matlab/Simulink to work with Arduino might also be needed.
Please reference this page to see how to connect your Arduino with Matlab/Simulink:
https://www.mathworks.com/help/supportpkg/arduino/ref/getting-started-with-arduino-hardware.html
This document will help with interfacing the servomotor:
https://www.mathworks.com/help/supportpkg/arduino/ref/servo-control.html
The student-supplied laptop will be needed to operate the real-time control workstation. In order to ensure
that the group has a Host available for the project at all times, it is recommended that each group
configure multiple Host computers with identical Matlab setups for redundancy.

# Tests to be Conducted
1. Demonstrate the ability to receive signals from a potentiometer and display the values themselves and
as a plot in Simulink.
2. Demonstrate the ability to turn a servo motor on or off upon command in Simulink.
3. Demonstrate turning the servo on or off upon achieving a given threshold of data value from the
potentiometer.

# Using 3D Designing Tools
1. Download 3D modeling software such as SolidWorks, Sketchup, Autodesk Fusion etc.
2. Design an approximately 4”x2”x1”(LxWxH) part – the height could be less than 1” to be printed on a
3D Printer. Use your imagination with the design – be sure to include the Team Number (and name if
you have one) embossed/debossed on it. Please ensure the design is reasonably within the bounds of
respectability though you can be humorous.

# Deliverables at the time of the demonstration
1. Demonstrate the tests to be conducted as above.
2. Simple slide show based on the requirements provided in the rubric on the next page.


# ECE 4950 Project 1 – Research Report Rubric
Each group will create a report that will eventually become a section in the “Research” section of your
final project website. Use the guidelines below to complete your report and add at the end of your report.

Group Number (Group Name optional):
Group Member Last Names:______________________________________________________________
Score Pts
## 15pts General Format - Professional Looking Document/Preparation (whole document) O3-SA1:1
1. Fonts, margins (11pt, times new roman, single spaced. 1" margins on all sides).
1. Spelling and grammar are correct
1. Layout of pictures – all figures need numbers and captions and must be referenced in
the text
1. Follows the page limitations below.
1. References. Use IEEE reference format.
1. This grading sheet is included as the final page.

## 15 pts Page 1: Title, Group Name, Group Members, and Date O3-SA1:1
Executive Summary (~1/3 of the page)
Provide a summary of the whole project. Use language that targets a non-technical audience.
An important skill for an engineer is to communicate complex technical information to a general
audience that may be involved in decision making, e.g. marketing. Important criteria:
1. Can a non-technical audience (~ high-school degree) read this section and understand
your goals, procedures, and conclusions?
1. Use simple words and graphics to help explain

## 30 pts The next sections of the report follow the standard laboratory report format. O2-SA2:3, O1-SA5:4
Page 2: Materials and Methods for the Sensor/Actuator Demonstration (1 page)
You are establishing the credibility and usefulness of your results by providing all the details so
that someone else could repeat your experiment. As an example, MATLAB 2021a may behave
differently than MATLAB 2021b – the software version information which would be required to
reproduce your result should be included. This section should answer the following:
1. What equipment is used, include software versions.
1. How were the experiments conducted? How is the equipment connected and used?
Describe the instrumentation, cables, connections, and experiments using diagrams and
photos. You should have drawings (pin connection and connector part numbers)
Pages 3-4: Results and Discussion for the Experiments (~1 page)
Describe what you have done. Include plots (from MATLAB, not photos of the Target screen)
for each of the three experiments and a brief discussion of how you interpret the result. Did you
demonstrate (through your documentation) that the equipment has been configured and used correctly?

## 5pts Page 4-5: Conclusions and References (~ 1 page) O3-SA1:1
1. Based on this experiment, do you recommend this equipment for use in a robot control
project? What are the possible limitations? Your results and observations should be the
basis for your conclusions. (~1/2 page)
1. What are the possible uses for the 3D Printer in your projects? (~1/4 page)
1. What did you learn from the process of determining your final project design?
Page 6: This Grading Sheet

## 5pts 3D Designed Part Grading based on: O7-SA1:1
1. Does the design meet the requirements?
1. Originality and creativity

## 10 Demo Slide Show Presentation (~3 slides)
1. What did you do to complete this project
1. How did all the team members get involved
1. Photos of the designed 3D model
