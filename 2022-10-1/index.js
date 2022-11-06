let theShader
SH = false
const size = 500
let time = 0

if (SH) {
	function preload() {
		theShader = loadShader('./vert.glsl', './frag.glsl')
	}
}

function setup() {
	createCanvas(size, size, SH ? WEBGL : null)
	noStroke()
}

function doShader() {
	shader(theShader)

	time += 0.01

	theShader.setUniform('u_resolution', [width, height])
	theShader.setUniform('u_mouse', [mouseX, mouseY])
	theShader.setUniform('u_time', time)

	rect(0, 0, width, height)
}

function draw() {
	if (SH) {
		doShader()
	} else {
		// this is me trying to figure out why this function works to create a polygon
		// i still don't really get it tho :(
		// val = floor(a / slice + 0.5) * slice - a;
		// float d = cos(val) * length(st);

		background(230)
		fill(0)
		textSize(20)
		textAlign(CENTER)
		translate(width / 2, height / 2)
		scale(0.5, 0.5)
		let slice = TWO_PI / 3

		for (let valx = -8; valx < 10; valx += 1) {
			for (let valy = -8; valy < 10; valy += 1) {
				fill(0)
				let x = valx / 10
				let y = valy / 10

				let vec = createVector(x, y)

				let angle = atan2(x, y) + PI
				// let val = floor(angle / slice + 0.5) * slice - angle
				let val = floor(angle / slice + 0.5) * slice - angle

				let cosval = cos(val)
				let cosvalstr = cosval.toString()
				cosvalstr = cosvalstr.includes('e') ? 0 : cosvalstr.slice(0, 4)
				let thisval = cosval * vec.mag()

				if (valy % 4 === 0 && valx % 4 === 0) {
					textSize(14)
					text(`${x}, ${y}`, width * x, height * y - 30)
					textSize(20)
					text(`val = ${round(val, 1)}`, width * x, height * y - 5)
					text(`cos(val) = ${cosvalstr}`, width * x, height * y + 20)

					text(
						`cos(val)*l = ${round(thisval, 2)}`,
						width * x,
						height * y + 45
					)
				}

				fill(0, 0, 0, 10)
				circle(width * x, height * y, thisval > 0.5 ? 20 : 5)
			}
		}
	}

	// let point = createVector(0.5, 0)
	// let angle = atan2(point.x, point.y) + PI

	// let val = floor(angle / slice + 0.5) * slice - angle

	// text(val, width / 2, height / 2)
}

// function windowResized() {
// 	resizeCanvas(windowWidth, windowHeight)
// }
