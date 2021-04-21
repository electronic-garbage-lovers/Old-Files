bluetooth_module_longth = 30+1;//长30mm
bluetooth_module_width = 15;//宽15mm
bluetooth_module_PCB_heigth  = 1.05;//PCB厚度1.05
chip1heigth = 2.64-1.05;
chip1longth = 5.03;
chip1width = 4.11 ;
chip2_heigth = 1.85-1.05;
chip2_longth = 3.98;

button_longth  =5.08;
button_longth2  =3.73;
button_Maxheight = 2.6-bluetooth_module_PCB_heigth;//释放按键时候的厚度
button_Minheight = 2.4-bluetooth_module_PCB_heigth;//按下按键的时候的厚度
button_baseheight = 2.33-bluetooth_module_PCB_heigth;//按键底座厚度
button_baseheight2 = 1.91-bluetooth_module_PCB_heigth;//按键底座厚度
hole1_r = 1.7/2;
hole1_distance_to_x =  1.8+hole1_r;
hole1_distance_to_y =  3.22+hole1_r;
hole2_r = 1.2/2;
hole2_distance_to_x =  12+hole2_r;
hole2_distance_to_y =  3.38+hole2_r;
hole3_r = 1.16/2;
hole3_distance_to_x =  26.48+hole3_r;
hole3_distance_to_y =  2+hole3_r;
hole4_r = 1.67/2;
hole4_distance_to_x =  26.2+hole4_r;
hole4_distance_to_y =  11.8+hole4_r;

btn_distance_to_y_border = 10.03-button_longth;
btn_distance_to_x_border = 9.55-button_longth;

battery_width  =5.2;
support_height = button_Maxheight+bluetooth_module_PCB_heigth+battery_width;

box_border_widht = 0.8;
            
            box_border_height = 0.8;
            // box_border_height = 2;
            box_border_zoffset = -support_height+button_Maxheight+bluetooth_module_PCB_heigth-box_border_widht;
            translate([-box_border_widht, -box_border_widht, box_border_zoffset]) 
            {
                cube(size=[bluetooth_module_longth+box_border_widht*2, bluetooth_module_width+box_border_widht*2, box_border_height]);//PCB
            }