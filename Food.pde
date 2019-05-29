class Food {
   Food(Point point) {
     this.point = point;
     this.original_point = new Point(this.point.x, this.point.y);
     this.tick = 0;
   }
   
   Point getPoint() {
     return point; 
   }
   
   void update() {
     this.tick++;
     this.point.y = this.original_point.y + sin((float)this.tick / 10) * 5;
   }
   
   void draw() {
    ellipseMode(CENTER);
    noStroke();
    
    fill(SHADOW_COLOR);
    circle(this.point.x, this.original_point.y + SHADOW_OFFSET, 20);
    
    fill(color(60, 40, 100));
    circle(this.point.x, this.point.y, 20);
   }
   
   Point point;
   Point original_point;
   int tick;
}
