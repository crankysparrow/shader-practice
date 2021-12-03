let theShader
const size = 500

function preload() {
	theShader = loadShader('./vert.glsl', './frag.glsl')
}

function setup() {
	createCanvas(size, size, WEBGL)
	noStroke()
}

function draw() {
	shader(theShader)

	theShader.setUniform('u_resolution', [width, height])
	theShader.setUniform('u_mouse', [mouseX, mouseY])

	rect(0, 0, width, height)
}

// function windowResized() {
// 	resizeCanvas(windowWidth, windowHeight)
// }
