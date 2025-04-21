---
editor_options: 
  markdown: 
    wrap: 72
---

## Functions in R

This activity aims to demonstrate how we can use functions
in R to make our code more reproducible and modular. We will
write a function to calculate growing degree days. For this,
we will use this formula:
$$\frac{(max.temp + min.temp)}{2} - base.temp$$

We will start with a very simple function and add complexity
together. We can vary the base temperature value, or add an
argument for planting dates, for example. The data used on
this exercise was retrieved from the Iowa Environmental
Mesonet on April 21st, 2025 and contains data from the year
of 2024 for a weather station near Ames, Iowa.
