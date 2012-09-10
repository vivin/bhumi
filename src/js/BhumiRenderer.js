var BhumiRenderer = (function() {

    function initialize(world) {

        console.log(world);

        //Find out all the different layers that we have
        var layers = [];

        for(var i = 0; i < world.snapshots.length; i++) {
            var snapshot = world.snapshots[i];

            for(var layer in snapshot.layers) if(snapshot.layers.hasOwnProperty(layer)) {
                if(layers.indexOf(layer) == -1) {
                    layers.push(layer);
                }
            }
        }

        var $canvas = jQuery("<canvas width=\"800\" height=\"600\"></canvas>");
        $canvas.css("border", "1px solid #000000");
        jQuery("body").append($canvas);


        var x = 0;
        var y = 0;
        var xIncrement = 800 / world.rows;
        var yIncrement = 600 / world.columns;

        var canvas = $canvas.get(0);
        var context = canvas.getContext('2d');

        context.lineWidth = 1;

        for(x = 0; x < 800; x += xIncrement) {
            context.beginPath();
            context.moveTo(x, 0);
            context.lineTo(x, 600);
            context.stroke();
        }

        for(y = 0; y < 600; y += yIncrement) {
            context.beginPath();
            context.moveTo(0, y);
            context.lineTo(800, y);
            context.stroke();
        }

        var colors = ["rgb(150, 29, 28)", "rgb(29, 150, 28)"];

        var index = 0;
        var iteration = 0;

        var intervalId = setInterval(function() {
            if(index == world.snapshots.length) {
                clearInterval(intervalId);
            } else {
                jQuery("#iterationDiv").text("Iteration: " + iteration);
                clear(world, canvas);

                var snapshot = world.snapshots[index];

                for(var layer in snapshot.layers) if(snapshot.layers.hasOwnProperty(layer)) {
                    var bugs = snapshot.layers[layer];

                    for(var i = 0; i < bugs.length; i++) {
                        var color = bugs[i].infected ? colors[0] : colors[1];
                        drawBug(world, canvas, bugs[i], color);
                    }
                }

                index++;
                iteration += world.snapshotInterval;
            }

        }, 250);

        clear(world, canvas);
    }

    function drawBug(world, canvas, bug, color) {
        var xIncrement = 800 / world.rows;
        var yIncrement = 600 / world.columns;

        var context = canvas.getContext('2d');
        context.fillStyle = color;
        context.fillRect((bug.x * xIncrement) + 1, (bug.y * yIncrement) + 1, xIncrement - 1, yIncrement - 1);
    }

    function clear(world, canvas) {
        var x = 0;
        var y = 0;
        var xIncrement = 800 / world.rows;
        var yIncrement = 600 / world.columns;

        var context = canvas.getContext('2d');

        for(x = 0; x < 800; x += xIncrement) {
            for(y = 0; y < 600; y += yIncrement) {
                context.fillStyle = "rgb(255, 255, 255)";
                context.fillRect(x + 1, y + 1, xIncrement - 1, yIncrement - 1);
            }
        }
    }

    return {
        initialize: initialize
    };

})();
