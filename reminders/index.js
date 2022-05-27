let theShader
const size = 500
let time = 0

function preload() {
	theShader = loadShader('./vert.glsl', './frag.glsl')
}

function setup() {
	pixelDensity(1)
	createCanvas(size, size, WEBGL)
	noStroke()
}

function draw() {
	shader(theShader)

	time++

	theShader.setUniform('u_resolution', [width, height])
	theShader.setUniform('u_mouse', [mouseX, mouseY])
	theShader.setUniform('u_time', time)

	rect(0, 0, width, height)
}

// function windowResized() {
// 	resizeCanvas(windowWidth, windowHeight)
// }
