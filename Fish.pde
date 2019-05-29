float mod(float x, float mod) {
  return (x + mod) % mod; 
}

class Fish {
  Fish(int head_size, float shrink_size, int tail_size, float hue) {
    tail_points = new ArrayList<Point>();
    
    this.x = random(0, width);
    this.y = random(0, height);
    for(int i = 0; i < tail_size; i++) {
      tail_points.add(new Point(this.x, this.y)); 
    }
    
    this.angle = random(0, TWO_PI);
    this.target_angle = this.angle;
    
    this.speed = 3;
    this.target_speed = this.speed;
    
    this.head_size = head_size;
    this.shrink_size = shrink_size;
    
    this.bias = 0.05;
    this.tick = (int)random(0, 10);
    
    this.base_saturation = 30;
    this.curr_saturation = this.base_saturation;
    
    this.food_range = 300;
    
    this.hue = hue;
  }
  
  void update() {
    this.tick++;
    this.checkFoodEat();
    
    // Move the current angle along a sine wave to make the fish paddle. 
    float adjusted_angle = this.angle;
    adjusted_angle += sin((float)this.tick / 10) / 3;
    
    // Move in the current direction.
    float x_speed = this.speed * cos(adjusted_angle);
    float y_speed = this.speed * sin(adjusted_angle);
    this.x = mod(this.x + x_speed, width);
    this.y = mod(this.y + y_speed, height);
    
    // Remove oldest tail and add newest tail.
    this.tail_points.remove(tail_points.size() - 1);
    this.tail_points.add(0, new Point(this.x, this.y));

    // Set target angle to food if it exists.
    Food closest_food = this.getClosestFood();
    if(closest_food != null) {
      this.target_angle = getAngleToFood(closest_food);
      this.target_speed = 4;
    }
    else {
      // Change direction and speed randomly.
      if(random(0, 1) < 0.01) {
        this.target_angle = random(0, TWO_PI);
      }
      if(random(0, 1) < 0.01) {
        this.target_speed = random(2, 3);
      }
    }
    
    // Elastically appraoch our target speed.
    this.speed = this.target_speed * this.bias + this.speed * (1 - this.bias);
    
    // Elastially approach our final target angle.
    float angle_dist = atan2(sin(this.target_angle - this.angle), cos(this.target_angle - this.angle));
    this.angle = (this.angle + angle_dist) * this.bias + this.angle * (1 - this.bias);
    this.angle = this.angle % (TWO_PI);
    
    // Constantly reduce saturation to base saturation to show food wearing off.
    this.curr_saturation = max(this.curr_saturation - 0.1, this.base_saturation);
  }
 
  void draw() {
    ellipseMode(CENTER);
    noStroke();
    
    // Draw the shadows.
    for(int i = 0; i < tail_points.size(); i++) {
      Point tail_point = tail_points.get(i);
      fill(SHADOW_COLOR);
      circle(tail_point.x, tail_point.y + SHADOW_OFFSET, this.head_size - i * shrink_size);
    }
    
    // Draw the body.
    for(int i = 0; i < tail_points.size(); i++) {
      Point tail_point = tail_points.get(i);
      fill(color(this.hue, this.curr_saturation - i / 2, 100));
      circle(tail_point.x, tail_point.y, this.head_size - i * shrink_size);
    }
  }
  
  private Food getClosestFood() {
    // Get the closest food within this fishes food range.
    float min_dist = 999999;
    Food closest_food = null;
    for(Food food : foods) {
       Point food_point = food.getPoint();
       Point head_point = tail_points.get(0);
       float dist = dist(food_point.x, food_point.y, head_point.x, head_point.y);
       
       if(dist < this.food_range && dist < min_dist) {
         min_dist = dist;
         closest_food = food;
       }
    }
    return closest_food;
  }
  
  private float getAngleToFood(Food food) {
    Point food_point = food.getPoint();
    float delta_x = food_point.x - tail_points.get(0).x;
    float delta_y = food_point.y - tail_points.get(0).y;
    return atan2(delta_y, delta_x);
  }
  
  private void checkFoodEat() { 
    // Check if we are colliding with a food.
    Food to_remove = null;
    for(Food food : foods) {
       Point food_point = food.getPoint();
       Point head_point = tail_points.get(0);
       if(dist(food_point.x, food_point.y, head_point.x, head_point.y) < this.head_size / 2) {
         to_remove = food; 
         break;
       }
    }
    if(to_remove != null) {
      // Increase the saturation to show that this fish has eaten food.
      this.curr_saturation += 20;
      
      // Delete the food.
      foods.remove(to_remove); 
    }
  }
 
  float x;
  float y;
  float angle;
  float speed;
  int head_size;
  float shrink_size;
  float bias;
  float min_dist;
  
  ArrayList<Point> tail_points;
  int update_count;
  float target_angle;
  float target_speed;
  
  int tick;
  
  float base_saturation;
  float curr_saturation;
  
  float food_range;
  
  float hue;
};
