precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

float square(vec2 ctr, float radius) {
    vec2 bottom_left = step(0.5 - radius, ctr);
    vec2 top_right =  step(0.5 - radius, 1.0 - ctr);

    return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

float outlineSquare(vec2 coord, float thickness, float edge) {
    float outer = square(coord, edge);
    float inner = square(coord, edge + thickness);

    return outer - inner;
}

float circle(vec2 p, float radius) {
  return step(length(p), radius);
}

float smoothedge(float v) {
    return smoothstep(0.0, 1.0 / u_resolution.x, v);
}


void main() {
    vec2 coord = gl_FragCoord.xy / u_resolution;

    float col = 0.0;
    // col = square(coord + vec2(0.25), 0.1) - square(coord + vec2(0.25), 0.09);
    vec2 bottomLeft = coord + vec2(0.5);
    vec2 topRight = coord - vec2(0.5);

    float radiusLg = fract(u_time * 0.005);
    // float radiusLg = 0.25;
    float px = 2.0 / u_resolution.x;
    float radiusSm = fract(u_time * 0.005) - 0.5;
    col += square(bottomLeft, radiusLg) - square(bottomLeft, radiusLg - px);
    col += square(topRight, radiusLg) - square(topRight, radiusLg - px);

    col += square(coord, radiusLg) - square(coord, radiusLg - px);
    // col += square(coord, radiusLg - 0.25) - square(coord, radiusLg - 0.25 - 0.01);
    col += square(coord, radiusLg - 0.5) - square(coord, radiusLg - 0.5 - 0.01);
    // col += square(coord, fract(corner + 0.25)) - square(coord, fract(corner + 0.25 - 0.01));

    // col += square(coord, corner + 0.5);
    // col = smoothedge(col);

    gl_FragColor = vec4(col, col, 0, 1.0);

}