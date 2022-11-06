precision mediump float;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

void main() {

  vec2 st = vTexCoord;
  st = st * 2.0 - 1.0;

  float col = 1.0;

  float a = atan(st.x, st.y);
  float slice = TWO_PI / 3.0;

  // Shaping function that modulate the distance
  float val = floor(a / slice + 0.5) * slice - a;

  float d = cos(val) * length(st);

  col = step(d, 0.5);
  // col = val;

  gl_FragColor = vec4(vec3(col), 1.0);
}