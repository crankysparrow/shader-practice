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
  // st -= 10.0;

  // st = fract(st);

  col += cos(st.y * abs(cos(u_time))) + sin(st.x * abs(sin(u_time)));

  col += sin(st.x * sin(u_time * -0.05));
  col += cos(st.y * sin(u_time * 0.03));

  gl_FragColor = vec4(vec3(abs(cos(col * 2.0)), abs(cos(col * 1.3)), col), 1.0);
}