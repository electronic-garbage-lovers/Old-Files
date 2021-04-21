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
module MicroUsb()
{
    hull()
    {
        translate([0, (8-6.4)/2, 0])
        cube([5,6.4,2.05]);
        cube(size=[5, 8, 0.95]);
    }
}
            // translate([28, 3.7, -3.7]) 
            //     MicroUsb();
module module_PCBA() {
    // body...
    union()
    {

        translate([btn_distance_to_x_border, btn_distance_to_y_border, bluetooth_module_PCB_heigth]) 
        {
            color([240/255, 240/255, 240/255]) {
                union()//正面按键
                {
                    cube([button_longth,button_longth,button_baseheight2]);
                    translate([(button_longth-button_longth2)/2, (button_longth-button_longth2)/2, 0]) 
                        cube([button_longth2,button_longth2,button_baseheight]);
                    translate([(button_longth)/2, (button_longth)/2, 0]) 
                        cylinder(r=1, h=button_Maxheight, $fn=48);
                }
            }

            
        }
        //PCB
        difference()
        {
            cube(size=[bluetooth_module_longth, bluetooth_module_width, bluetooth_module_PCB_heigth]);//PCB
            union()
            {
                translate([hole1_distance_to_y, hole1_distance_to_x, -0.05]) 
                    cylinder(r=hole1_r,h=bluetooth_module_PCB_heigth+0.1, $fn=48);
                translate([hole2_distance_to_y, hole2_distance_to_x, -0.05]) 
                    cylinder(r=hole2_r,h=bluetooth_module_PCB_heigth+0.1, $fn=48);
                translate([hole3_distance_to_x, hole3_distance_to_y, -0.05]) 
                    cylinder(r=hole3_r,h=bluetooth_module_PCB_heigth+0.1, $fn=48);
                translate([hole4_distance_to_x, hole4_distance_to_y, -0.05]) 
                    cylinder(r=hole4_r,h=bluetooth_module_PCB_heigth+0.1, $fn=48);  
            }
                                             
        }
        union()//底部几个较高的芯片
        {
            color([20/255, 30/255, 30/255]) 
            {
                translate([7.5,9.34 , -chip1heigth]) 
                {
                    cube(size=[chip1width, chip1longth, chip1heigth]);
                }
                translate([15.94,5 , -chip2_heigth]) 
                {
                    cube(size=[chip2_longth, chip2_longth, chip2_heigth]);
                }
            }

            
        }
        
    }

}
module Top()
{
    union()
    {
        translate([0,0,bluetooth_module_PCB_heigth+button_Maxheight])
        difference()//顶盖部分
        {
            cube(size=[bluetooth_module_longth+0.1, bluetooth_module_width+0.1, bluetooth_module_PCB_heigth]);//PCB
            translate([btn_distance_to_x_border, btn_distance_to_y_border, -0.05]) 
            {
                translate([(button_longth)/2, (button_longth)/2, 0])
                {
                    union()
                    {
                        cylinder(r=2.1, h=bluetooth_module_PCB_heigth+0.1, $fn=48);
                        cylinder(r=2.8, h=bluetooth_module_PCB_heigth/2+0.1, $fn=48);
                    }
                    
                } 
                    
            }
        }
        difference()//四周
        {
            
            box_border_height = support_height+bluetooth_module_PCB_heigth+box_border_widht;
            // box_border_height = 2;
            box_border_zoffset = -support_height+button_Maxheight+bluetooth_module_PCB_heigth-box_border_widht;
            translate([-box_border_widht, -box_border_widht, box_border_zoffset]) 
            {
                cube(size=[bluetooth_module_longth+box_border_widht*2, bluetooth_module_width+box_border_widht*2, box_border_height]);//PCB
            }
            translate([0,0, box_border_zoffset-0.05]) 
            cube(size=[bluetooth_module_longth+0.1, bluetooth_module_width+0.1, box_border_height+0.1]);//PCB
            translate([28, 3.7, -3.7]) 
                MicroUsb();
        }
        union()//四个过孔的支柱
        {
            support_height = button_Maxheight+bluetooth_module_PCB_heigth+2;
            support_height_b  = button_Maxheight;
            translate([0,0,bluetooth_module_PCB_heigth+button_Maxheight-support_height])
            union()
            {
                translate([hole1_distance_to_y, hole1_distance_to_x, 0]) 
                    cylinder(r=hole1_r-0.15,h=support_height, $fn=48);
                translate([hole2_distance_to_y, hole2_distance_to_x, 0]) 
                    cylinder(r=hole2_r-0.15,h=support_height, $fn=48);
                translate([hole3_distance_to_x, hole3_distance_to_y, 0]) 
                    cylinder(r=hole3_r-0.15,h=support_height, $fn=48);
                translate([hole4_distance_to_x, hole4_distance_to_y, 0]) 
                    cylinder(r=hole4_r-0.15,h=support_height, $fn=48);  
            }
            translate([0,0,bluetooth_module_PCB_heigth+button_Maxheight-support_height_b])
            union()
            {
                translate([hole1_distance_to_y, hole1_distance_to_x, 0]) 
                    cylinder(r=hole1_r+0.25,h=support_height_b, $fn=48);
                translate([hole2_distance_to_y, hole2_distance_to_x, 0]) 
                    cylinder(r=hole2_r+0.25,h=support_height_b, $fn=48);
                translate([hole3_distance_to_x, hole3_distance_to_y, 0]) 
                    cylinder(r=hole3_r+0.25,h=support_height_b, $fn=48);
                translate([hole4_distance_to_x, hole4_distance_to_y, 0]) 
                    cylinder(r=hole4_r+0.25,h=support_height_b, $fn=48);  
            }
        }
            
    }
}
module button()
{
    translate([0,0,bluetooth_module_PCB_heigth+button_Maxheight])
        translate([btn_distance_to_x_border, btn_distance_to_y_border, 0]) 
        {
            translate([(button_longth)/2, (button_longth)/2, 0])
            {
                difference()
                {
                    union()
                    {
                    cylinder(r=2-0.1, h=bluetooth_module_PCB_heigth+1.2, $fn=48);
                    cylinder(r=2.8-0.3, h=bluetooth_module_PCB_heigth/2-0.05, $fn=48);
                    }
                    cylinder(r=1.08, h=0.1, $fn=48);
                }

            } 
                
        } 
}
module bottom()
{
    union()
    {
            translate([-0.8, -0.8, -box_border_widht-battery_width]) {
        cube(size=[bluetooth_module_longth+1.6, bluetooth_module_width+0.8*2 , box_border_widht]);//P
    }//这里一堆0.8是修改了底盖的方式
        union()//四个过孔的支柱
        {
            support_height = battery_width+0.1+0.7;
            support_height_b  = battery_width+0.7;//0.7是补偿
            translate([0,0,-support_height_b])
            difference()
            {
                union()
                {
                    translate([hole1_distance_to_y, hole1_distance_to_x, 0]) 
                        cylinder(r=hole1_r+0.3,h=support_height_b, $fn=48);
                    translate([hole2_distance_to_y, hole2_distance_to_x, 0]) 
                        cylinder(r=hole2_r+0.3,h=support_height_b, $fn=48);
                    translate([hole3_distance_to_x, hole3_distance_to_y, 0]) 
                        cylinder(r=hole3_r+0.3,h=support_height_b, $fn=48);
                    translate([hole4_distance_to_x, hole4_distance_to_y, 0]) 
                        cylinder(r=hole4_r+0.3,h=support_height_b, $fn=48);  
                }
                union()
                {
                    translate([hole1_distance_to_y, hole1_distance_to_x, 0]) 
                        cylinder(r=hole1_r+0.05,h=support_height, $fn=48);
                    translate([hole2_distance_to_y, hole2_distance_to_x, 0]) 
                        cylinder(r=hole2_r+0.05,h=support_height, $fn=48);
                    translate([hole3_distance_to_x, hole3_distance_to_y, 0]) 
                        cylinder(r=hole3_r+0.05,h=support_height, $fn=48);
                    translate([hole4_distance_to_x, hole4_distance_to_y, 0]) 
                        cylinder(r=hole4_r+0.05,h=support_height, $fn=48);  
                }
            }

            //translate([0,0,bluetooth_module_PCB_heigth+button_Maxheight-support_height_b])

        }
    }

    
}
Top();
button();
module_PCBA();
!bottom();
//截面分析
// intersection()
// {
//     Top();
//     translate([-20,0,0])
//         cube([30,30,30]);
    
// }