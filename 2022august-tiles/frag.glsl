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

float box(vec2 coord, float _size) {
  float edge = (1.0 - _size) * 0.5;
  vec2 bl = smoothstep(edge, edge + 0.001, coord);
  vec2 tr = smoothstep(edge, edge + 0.001, 1.0 - coord);
  return bl.x * bl.y * tr.x * tr.y;
}

float outline(vec2 coord, float _size) {
  float outer = box(coord, _size);
  float inner = box(coord, _size - 0.05);

  return outer - inner;
}

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle),
              sin(_angle), cos(_angle));
}

float rect(vec2 coord, vec2 size) {
    vec2 edges = (vec2(1.0) - size) / 2.0;
    float bottom = step(edges.y, coord.y);
    float left = step(edges.x, coord.x);
    float right = 1.0 - step(edges.x + size.x, coord.x);
    float top = 1.0 - step(edges.y + size.y, coord.y);

    return bottom * left * right * top;
}

float outlinerect(vec2 coord, vec2 size) {
    float outer = rect(coord, size);
    float inner = rect(coord, size - vec2(0.05));
    return outer - inner;
}

void main() {
  vec2 st = vTexCoord;

  st *= 4.0;
  st = fract(st);

  float col = 0.1;

  vec2 topmid = st - vec2(0.5, 0.75);
  topmid = rotate2d(PI * 0.25) * topmid * 2.0;
  topmid += 0.5;
  col += box(topmid, 0.7);

  vec2 topright = st - vec2(1., 0.75);
  topright = rotate2d(PI * 0.25) * topright * 2.0;
  topright += 0.5;
  col += outline(topright, 0.7);

  vec2 topleft = st - vec2(0., 0.75);
  topleft = rotate2d(PI * 0.25) * topleft * 2.0;
  topleft += 0.5;
  col += outline(topleft, 0.7);

  col += rect(st + vec2(0.5, 0.24), vec2(0.015, 0.5));
  col += rect(st + vec2(-0.5, 0.24), vec2(0.015, 0.5));
  col += rect(st + vec2(0.0, 0.5), vec2(1.0, 0.015));
  col += rect(st + vec2(0.0, 0.24), vec2(0.015, 0.5));

  gl_FragColor = vec4(vec3(col), 1.0);
}