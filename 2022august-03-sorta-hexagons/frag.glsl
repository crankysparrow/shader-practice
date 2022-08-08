precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

float circle( vec2 coord, float radius ) {
    float dist = distance(coord, vec2(0.5));
    return smoothstep(radius + 0.001, radius - 0.001, dist);
}

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle),
              sin(_angle), cos(_angle));
}

float box(vec2 coord, float _size) {
  float edge = (1.0 - _size) * 0.5;
  vec2 bl = smoothstep(edge, edge + 0.001, coord);
  vec2 tr = smoothstep(edge, edge + 0.001, 1.0 - coord);
  return bl.x * bl.y * tr.x * tr.y;
}

float rect(vec2 coord, vec2 size) {
    vec2 edges = (vec2(1.0) - size) / 2.0;
    float bottom = step(edges.y, coord.y);
    float left = step(edges.x, coord.x);
    float right = 1.0 - step(edges.x + size.x, coord.x);
    float top = 1.0 - step(edges.y + size.y, coord.y);

    return bottom * left * right * top;
}


void main() {
  vec2 st = vTexCoord;
  vec3 color = vec3(0.0);
  float d = 0.0;

  st *= 2.0;
  
  st *= mat2(2.0, 3.0, 
            2.0, -3.0);

  float odd_y = step(1.0, mod(st.y, 2.0)); 
  float odd_x = step(1.0, mod(st.x, 2.0));
  float tr = odd_y * odd_x;
  float br = odd_x * (1. - odd_y);
  float tl = (1.0 - odd_x) * odd_y;
  float bl = (1.0 - odd_x) * (1.0 - odd_y);


  st = fract(st);

  vec3 col = vec3(0.0, 0.0, 0.0);

  vec2 linemid_pts = st;
  linemid_pts -= vec2(0.5, 0.5);
  linemid_pts = rotate2d(PI * 0.25) * linemid_pts;
  linemid_pts += vec2(0.5, 0.5);
  float linemid = rect(linemid_pts, vec2(0.02, 1.5));
  col += vec3(linemid * br);

  vec2 lineshex_pts = st;
  // lineshex_pts += vec2(0.0, 0.48);
  float lineshex = rect(lineshex_pts + vec2(0.0, 0.49), vec2(1.0, 0.02));
  lineshex += rect(st + vec2(-0.49, 0.0), vec2(0.02, 1.0));
  col += vec3(lineshex * bl);

  // st.x += step(1.0, mod(st.y, 2.0)) * 0.5;

  // col += box(st, 0.5) * odd_y;
  // col += box(st, 0.5) * odd_x * 0.5;
  // col += box(st, 0.5) * tr;
  // col += box(st, 0.3) * tr * vec3(1.0, 0., 0.);
  // col += box(st, 0.5) * tl * vec3(0., 0.5, 0.);
  // col += box(st, 0.4) * bl * vec3(0.5, 0.0, 0.5);
  // col += box(st, 0.7) * br * vec3(1.0, 0.0, 1.0);

  col += vec3(0.7 * tl + 0.9 * bl, 0.0, 0.4 + 0.2 * tr + 0.5 * br);

  gl_FragColor = vec4(col, 1.0);
}