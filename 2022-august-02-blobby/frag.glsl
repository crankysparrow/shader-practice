precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

void main() {
  vec2 st = vTexCoord;

  float col = 0.1;

  st *= 25.0;

  // st = fract(st);

  col += cos(st.y * -1.0 * cos(u_time));
  col += sin(st.x * abs(sin(u_time)));

  col += sin(st.x * sin(u_time * -0.051));
  col += cos(st.y * sin(u_time * 0.05));

  float r = abs(cos(col * 2.0));
  float g = abs(cos(col));
  float b = col;

  gl_FragColor = vec4(r, g, b, 1.0);
}