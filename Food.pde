class Food {
   Food(Point point) {
     this.point = point;
   }
   
   Point getPoint() {
     return point; 
   }
   
   void draw() {
    ellipseMode(CENTER);
    noStroke();
    
    fill(SHADOW_COLOR);
    circle(this.point.x, this.point.y + SHADOW_OFFSET, 20);
    
    fill(color(60, 40, 100));
    circle(this.point.x, this.point.y, 20);
   }
   
   Point point;
}
