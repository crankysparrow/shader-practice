precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

float rect(vec2 coord, vec2 size) {
    vec2 edges = (vec2(1.0) - size) / 2.0;
    float bottom = step(edges.y, coord.y);
    float top = 1.0 - step(edges.y + size.y, coord.y);
    float left = step(edges.x, coord.x);
    float right = 1.0 - step(edges.x + size.x, coord.x);

    return bottom * top * left * right;
}

float outlineRect(vec2 coord, float thickness, vec2 size) {
    float outer = rect(coord, size);
    float inner = rect(coord, size - thickness);

    return outer - inner;
}

float square(vec2 coord, float size) {
    float edge = (1.0 - size) / 2.0;
    vec2 bottom_left = step(vec2(edge), coord);
    vec2 top_right =  step(vec2(edge), 1.0 - coord);

    return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

float outlineSquare(vec2 coord, float thickness, float size) {
    float outer = square(coord, size);
    float inner = square(coord, size - thickness);

    return outer - inner;
}


void main() {

    vec2 coord = vTexCoord;

    float r = 0.0; 
    r += outlineSquare(coord, 0.1, fract(u_time * 0.01) + 0.1);
    r += outlineSquare(coord, 0.1, fract(u_time * 0.01 - 0.3) + 0.1);

    gl_FragColor = vec4(r, 0.0, 0.0, 1.0);

}