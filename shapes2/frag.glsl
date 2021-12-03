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

void main() {

    vec2 coord = vTexCoord;

    float g = 0.0;
    g += rect(coord + vec2(0.3, -0.3), vec2(0.3, 0.2));       // top left
    g += rect(coord, vec2(0.12, 0.2));                        // middle
    g += rect(coord + vec2(-0.3, 0.3), vec2(0.35, 0.15));     // bottom right
    g += rect(coord + vec2(-0.3, -0.15), vec2(0.3, 0.4));     // top right (ish)

    float b = 0.0;
    b += rect(coord + vec2(-0.15, -0.2), vec2(0.35, 0.2));
    b += outlineRect(coord + vec2(0.2, 0.3), 0.1, vec2(0.4, 0.3));

    float r = outlineRect(coord + vec2(0.2, -0.1), 0.05, vec2(0.6, 0.7));
    r += outlineRect(coord + vec2(-0.15, 0.25), 0.03, vec2(0.6, 0.4));

    // col += outlineRect(coord + vec2(0.2, -0.1), 0.05, vec2(0.6, 0.7));

    // or we could make a rectangle by scaling/squishing a square
    // float col = square(coord * vec2(1.0, 1.5), 0.1);

    gl_FragColor = vec4(r, g, b, 1.0);

}