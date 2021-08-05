DYI ATX PSU
===========

![DYI ATX PSU](/pictures/psu.jpg "DYI ATX PSU")

DYI variable psu (1.2-60V/8A) based on a ATX power supply unit, with the following outputs:

- 3.3/5/12V 10A
- 1.2-12V 8A
- 12-60V 8A
- USB power/charge 3A


## Disclaimer

This is a personal project and all information is presented "as-is" without any guarantee whatsoever, including - but not only - regarding safety and accurracy. To be clear, if you use any information present in this repository, you are on your own. If you die from it, its your problem, not mine. 

Working with mains power may result in electric shock, serious injuries or even death. This project makes use of lethal voltages and currents, and appropriate protection is strongly advised. Additionally, these kind of projects may constitute a fire hazard and emit toxic fumes - never leave the apparatus working without proper supervision. If it burns down your house, kills your pet or your children, its your fault - you've been warned.

If you are evaluating this to save money, consider purchasing a proper PSU instead. Factoring in all the required parts and time, this project is actually more expensive than buying a cheap one from aliexpress or banggood.

## ATX PSU

This project uses a Cooler Master RS-500-PSAP-J3 ATX PSU. This specific PSU has a large fan on a side of the case, instead of a smaller one on the back. This design increases air flow, and is used in this project as a ventilation mechanism for the 3d printed case. Any other modern ATX PSU may be used, as long as it has the same ventilation design; using a classic fan-in-the-rear PSU may cause heat problems.

Please note that this particular PSU uses crappy AWG20 wiring, so desired output amperage is achieved by joining multiple wires for a given connection.

**Cooler Master RS500**
![Cooler Master RS500](/pictures/cooler_master_rs500.jpg "Cooler Master RS500")

## 3D Printed parts

|Name|STL|Description|
|---|---|---|
| enclosure.scad | | Main file; Edit to change dimensions|
| body.scad | body.stl | PSU Body|
| front_panel.scad | front.stl | PSU Frontal panel |
| test_plate.scad | test.stl | Hole test panel - print this to make sure your panel-mount components fit |


**Printed enclosure (body.scad)**
![Printed enclosure (body.scad)](/pictures/printed_enclosure.jpg "Printed enclosure (body.scad)")

**Printed front panel (front_panel.scad)**
![Printed front panel (front_panel.scad)](/pictures/printed_frontpanel.jpg "Printed front panel (front_panel.scad)")


### Print settings

Use PLA, PETG or ABS; Keep in mind PLA has low tolerance for high temperature, and may increase the risk of a fire hazard. Print body with at least 7% infill, and the front panel with at least 10% infill. Due to the body dimensions and the long print time, the body should be printed with a brim to prevent warping.

Be sure to print the test plate first, to check that your components fit. Also check the dimensions of your PSU to make sure it matches the predefined dimensions (86.5x151x140). If not, edit enclosure.scad accordingly and generate a new enclosure stl.

## Other parts

| Qty | Description | Link |
|---|---|---|
|1| 3mm Yellow Led | |
|1 | 3mm Green Led | |
|1 | 150R resistor, 1/8W| |
|1 | 50R resistor, 1/8W | |
|1 | 10R resistor, 50W | https://www.aliexpress.com/item/4000801474938.html |
|1 | 10K Potentiometer | |
|1 | 5K Potentiometer | |
|2| Digital Voltmeter Ampmeter Dual Display DC 0-100V 10A | https://www.aliexpress.com/item/1005002388342350.html|
|1| DC 400W 15A Step-up Boost Converter 8.5-50V to 10-60V | https://www.aliexpress.com/item/32947271203.html |
|1| DC-DC  Step Down  Voltage Regulator Module 200W XL4016 8A | https://www.aliexpress.com/item/4000259057666.html |
|1| Double USB charger | https://www.aliexpress.com/item/32870044984.html |
|5| Red Banana female jack M5 high current | https://www.aliexpress.com/item/32748606671.html |
|3| Black Banana female jack M5 high current | https://www.aliexpress.com/item/32748606671.html |
|6| 5x20mm panel mount glass fuse holder| https://www.aliexpress.com/item/32939712498.html |
|4| Brass thread insert nuts M3*5*4 | |
|4| M3 screws (those used to mount cdrom/dvd drives)||
|1| meter of 1.5mm red or brown copper cable||
|1| meter of 1.5mm blue or black copper cable||

## Assembly instructions

### Front sticker

If you are using the stock layout without any adjustments, just print the [front sticker](/front_sticker/front_panel_sticker.pdf). The supplied sticker is a bit different from the one used in the first picture, due to image copyright distribution issues. You can also edit [the svg layout](/front_sticker/front_panel_sticker.svg) to customize as you see fit.

Keep in mind, if any significant change was done to the front panel feature dimensions, you may need to design a different front sticker.

### Modules

Replace the adjustable trimmers in the DC step-up converters, and place wires to connect to potentiometers instead. Make sure these wires are at least 30cm.
Solder the 10R resistor to an available 5V rail and make sure to isolate the terminals.

**DC Modules and 50W resistor**
![DC Modules and 50W resistor](/pictures/dc_modules.jpg "DC Modules and 50W resistor")

### Front panel assembly

After printing the front panel, you can now mount the thread inserts on the side holes. Then place the USB connector support, and drill holes on the support plate as appropriate to hold the connector. In this specific assembly, the USB was fixated in place by using a piece of metal cable tie and hot glue.
Glue the front sticker to the front panel, and mount the components. Ideally, you should place the M5 bananas and fuse mounts one by one, as they need to be connected to each other and there isn't much space available. The potentiometers should be placed last.

There isn't much space available for the potentiometers, make sure you solder the wires on the available holes and trim the pins, to reduce the final size. The wires should be paralell to the shaft.


### Wiring

Follow the schematic [here](/schematic/schematic_v1.0.png). When connecting high-amperage lines such as +3.3V, +5V and +12V and GND from the PSU, use multiple wires combined. Most ATX PSUs won't be able to provide 8-10A on a single wire. When doing this, be sure don't mix the striped yellow with solid yellow cables; they usually represent different 12V rails and doing it may damage the PSU or any connected devices.

The connections between the fuse holder and the M5 banana should be done with 1.5mm cable, as well as the connections from the DC modules to the fuses and the VA meters.

Make sure you isolate all connections with heat shrink tubing. Check with a multimeter if there is no shorts between the power rails and the ground. Do not forget to connect the brown wire (3.3v sense) to the 3.3V rail, or the PSU will not turn on.
