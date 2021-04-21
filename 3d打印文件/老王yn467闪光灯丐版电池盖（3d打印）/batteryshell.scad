cover_width  = 18.1;//盖子宽度
cover_length = 67.9;//盖子总长（除去小耳朵）
cover_h = 4.3;//盖子是斜面，这里是最厚的地方
cover_h2 = 3.4;//
cover_interal_length = 65.2;//盖子内部总长
clip_w = 4.7;//盖子上大卡扣的宽度
clip_h = 1.5;//盖子上大卡扣的厚度
clip_deep=2.2;//盖子上大卡扣的深度
difference()
{
translate([0, 0, -cover_h2/2]) 
cube(size=[cover_width, cover_length, cover_h2], center=true);
translate([cover_width/2-0.4, 0, -(2.42)/2]) 
cube(size=[0.8, 100, 2.42], center=true);
translate([-cover_width/2+0.4, 0, -(2.42)/2]) 
cube(size=[0.8, 100, 2.42], center=true);

translate([0, 35, -7.5]) 
rotate([40, 0, 0]) 
cube(size=[100, 10, 10], center=true);
translate([0, -33, -1.2])
cube(size=[7, 3, 2.5], center=true); 
}//主题
translate([0, 0.2, 0]) {
    union()
{
translate([0, cover_length/2-(cover_length-cover_interal_length)/2, 4.8/2]) 
cube(size=[cover_width-1, 2, 4.8], center=true);

translate([0, cover_length/2-3.2  , clip_h/2+cover_h2]) 
cube(size=[clip_w, clip_deep, clip_h], center=true);

}
}


translate([-0.8, 0, 0]) 
{
    translate([(cover_width-3.1)/2, -(cover_length+4.63-2.42)/2, 1.89/2]) 
cube(size=[3.1, 4.63+2.42, 1.89], center=true);
translate([(cover_width+5.4)/2-3.1, -(cover_length+7.4)/2, 1.89/2]) 
rotate([0, 90, 0]) {
    cylinder(r=1, h=5.4, center=true,$fn=36);
}
}

translate([0.8, 0, 0]) 
{
    translate([-(cover_width-3.1)/2, -(cover_length+4.63-2.42)/2, 1.89/2]) 
cube(size=[3.1, 4.63+2.42, 1.89], center=true);
translate([-(cover_width+5.4)/2+3.1, -(cover_length+7.4)/2, 1.89/2]) 
rotate([0, 90, 0]) {
    cylinder(r=1, h=5.4, center=true,$fn=36);
}
}

