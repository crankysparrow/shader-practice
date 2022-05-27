precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

float circle( vec2 coord, float radius ) {
    float dist = distance(coord, vec2(0.5));
    return smoothstep(radius + 0.001, radius - 0.001, dist);
}

// void main() {

//     vec2 coord = vTexCoord;
//     coord = 2.0 * coord - 1.;

//     float c = 0.0;

//     float dist1 = distance(coord, vec2(0.5, 1.0));
//     c += smoothstep(0.3001, 0.299, dist1);

//     float dist2 = distance(coord, vec2(0.5, 0.0));
//     c += smoothstep(0.3001, 0.299, dist2);

//     vec3 color = vec3(coord.x, 1.0, coord.y);

//     gl_FragColor = vec4(vec3(fract(c * 2.0)), 1.0);
//     // gl_FragColor = vec4(color - c,1.0);

// }

void main() {
  vec2 st = vTexCoord;
  vec3 color = vec3(0.0);
  float d = 0.0;

  // Remap the space to -1. to 1.
//   st = st *2.-1.;

  // Make the distance field
  d = length( abs(st)-.5 );
    d = length(max(st - vec2(0.3, 0.8), 0.0));
  // d = length( max(abs(st)-.3,0.) );

  // Visualize the distance field
  gl_FragColor = vec4(vec3(fract(d * 10.0)),1.0);
    // gl_FragColor = vec4(vec3(d), 1.0);
}