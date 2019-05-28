Fish[] fishs;
ArrayList<Food> foods;

color SHADOW_COLOR = color(0, 0, 0, 20);
int SHADOW_OFFSET = 10;

void mousePressed() {
   foods.add(new Food(new Point(mouseX, mouseY)));
}

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  
  foods = new ArrayList<Food>();
  fishs = new Fish[30];
  for(int fish_idx = 0; fish_idx < fishs.length; fish_idx++) {
    fishs[fish_idx] = new Fish(30, 0.7, 40);
  }
}

void draw() {
  background(color(200, 100, 50));
  
  for(Fish fish : fishs) {
    fish.update();
  }

  for(Food food : foods) {
    food.draw(); 
  }
  for(Fish fish : fishs) {
    fish.draw();
  }
}
