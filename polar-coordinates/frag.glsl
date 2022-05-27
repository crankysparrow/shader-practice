#define TWO_PI 6.28318530718

precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

// cartesian --> polar coordinates: 
// https://thebookofshaders.com/06/ under "HSB in polar coordinates"
// https://thebookofshaders.com/07/ under "polar shapes"
// to map cartesian --> polar coords, calculate radius + angle of each pixel: 
    // vec2 pos = vec2(0.5) - st;     (st is the same as coord in this example)
    // float r = length(pos) * 2.0;
    // float a = atan(pos.y, pos.x);

void main() {

    vec2 coord = vTexCoord;
    vec3 color = vec3(0.0);

    vec2 pos = vec2(0.5) - coord;
    float r = length(pos) * 2.0;
    float angle = atan(pos.y, pos.x);

    float f = sin(angle * 3.0);
    color = vec3(smoothstep(f, f + 0.005, r));
    color = vec3(angle/TWO_PI + 0.5); 
        // (angle is in radians from -PI to PI, we want values between -0.5 and 0.5 instead)

    gl_FragColor = vec4(color, 1.0);

}
