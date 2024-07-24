$(document).ready(function() {
    let nSquares = 64;
    let colourNodesEndpoint = '/KubernetesLoadBalancer';

    function parseSquareColour(colourText) {
        if (colourText && (colourText === "green" || colourText === "blue")) {
            return colourText;
        }
        return 'red';
    }

    function setSquareColour(index, colourText=null) {
        let colour = parseSquareColour(colourText);
        $('#square-' + index).css('background-color', colour);
    }

    function scheduleNextUpdate(index) {
        setTimeout(function() {
            updateSquare(index);
        }, 1000);
    }

    function updateSquare(index) {
        $.get(colourNodesEndpoint)
            .done(function(response) {
                console.log('square' + index + ', response=' + response);
                setSquareColour(index, response);
            })
            .fail(function() {
                console.log('square' + index + ', fail');
                setSquareColour(index);
            })
            .always(function() {
                scheduleNextUpdate(index);
            });
    }

    function startSquareUpdates() {
        for (let index = 0; index < nSquares; index++) {
            updateSquare(index);
        }
    }

    startSquareUpdates();
});
