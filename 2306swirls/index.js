let theShader
let canvas
const size = 500
let time = 0

function makeImages(canvas) {
    let zip = new JSZip()
    let count = 0

    const getImage = () => {
        count++
        return new Promise((resolve, _reject) => {
            canvas.toBlob((blob) => {
                zip.file(`${count}.png`, blob)
                resolve(blob)
            })
        })
    }

    function downloadZip(name = 'images') {
        zip.generateAsync({ type: 'blob' }).then(function (content) {
            let url = URL.createObjectURL(content)
            download(url, `${name}.zip`)
        })
    }

    return { getImage, downloadZip }
}

function download(href, name) {
    let link = document.createElement('a')
    link.download = name
    link.style.opacity = '0'
    document.body.append(link)
    link.href = href
    link.click()
    link.remove()
}

function preload() {
    theShader = loadShader('./vert.glsl', './frag.glsl')
}

function setup() {
    canvas = createCanvas(size, size, WEBGL)
    noStroke()
    // noLoop()

    // let { getImage, downloadZip } = makeImages(canvas.elt)
    // function animate(t = 0) {
    //     redraw()
    //     console.log(t)
    //     getImage().then(() => {
    //         t++
    //         if (t === 1000) {
    //             downloadZip()
    //         } else {
    //             animate(t)
    //         }
    //     })
    // }
    // animate()
}

function draw() {
    shader(theShader)

    time += 0.01

    theShader.setUniform('u_resolution', [width, height])
    theShader.setUniform('u_mouse', [mouseX, mouseY])
    theShader.setUniform('u_time', time)

    rect(0, 0, width, height)
}

// function windowResized() {
// 	resizeCanvas(windowWidth, windowHeight)
// }
