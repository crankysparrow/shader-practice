#define TWO_PI 6.28318530718

precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {

    vec2 coord = vTexCoord;
    vec3 color = vec3(0.0);

    vec2 pos = vec2(0.5) - coord;
    float r = length(pos) * 2.0;
    float angle = atan(pos.y, pos.x);

    float iu = 1.0;
    iu = cos(angle * 8.0);
    iu = smoothstep(-2., -0.5, iu);
    iu *= 0.9;

    float ou = 1.0;
    ou = sin(angle * 12.0 + u_time * -0.1);
    ou *= 0.05;
    ou += 0.5;

    iu = 1.0 - smoothstep(iu, iu + 0.01, r);
    ou = 1.0 - smoothstep(ou, ou + 0.01, r);
    // color = vec3(ou);
    // color = vec3(iu);
    color = vec3(iu - ou);   


    gl_FragColor = vec4(color, 1.0);

}
