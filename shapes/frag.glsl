precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;

float square(vec2 coord, float edge) {
    vec2 bottom_left = step(vec2(edge), coord);
    vec2 top_right =  step(vec2(edge), 1.0 - coord);

    return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

float outlineSquare(vec2 coord, float thickness, float edge) {
    float outer = square(coord, edge);
    float inner = square(coord, edge + thickness);

    return outer - inner;
}

void main() {

    vec2 coord = vTexCoord;

    float col = outlineSquare(coord - vec2(0.3, 0.3), 0.03, 0.4);
    col += outlineSquare(coord, 0.05, 0.3);
    col += outlineSquare( coord + vec2(0.3, 0.3), 0.03, 0.4 );

    gl_FragColor = vec4(col, col, col, 1.0);

}