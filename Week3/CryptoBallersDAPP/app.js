window.onload = () => {
    getExistingBallerCount();
    getBallerPrice();
    getExistingBallers();
}

async function getExistingBallerCount() {
	let numBallers = await contract.getNumBallers();
    var ballerCount = document.getElementById('ballerCount');
	ballerCount.insertAdjacentHTML('beforeend', numBallers);
}

async function getBallerPrice() {
	let ballerPrice = await contract.getBallerPrice();
	ballerPrice = ballerPrice / 1000000000000000000;
    var price = document.getElementById('ballerPrice');
	price.insertAdjacentHTML('beforeend', ballerPrice);
}

async function getExistingBallers() {
    let numBallers = await contract.getNumBallers();
    for (var i = 0; i < numBallers; i++) {
        let baller = await contract.ballers(i);
        let owner = await contract.ownerOf(i);
        addBallerToUI(baller, owner, i);
    }
}

async function addBallerToUI(baller, owner, id) {
    $('#Ballers').append(getBallerHtml(baller.name, baller.level, baller.offenseSkill, baller.defenseSkill, baller.winCount, baller.lossCount, owner, id));
}

function getBallerHtml(name, level, offense, defense, winCount, lossCount, owner, id) {
    var html = `
    	<li class="baller">
    	<div class="card" style="width: 17rem;">
		  <img class="card-img-top" src="monster-baller.jpg" alt="Card image cap">
		  <div class="card-body">
			<h3 class="card-title"><i class="fab fa-ethereum"></i> ${name}<br/><span>#${id}</span></h3>
		  </div>
		  <ul class="attributes list-group list-group-flush">
			<li class="list-group-item"><i class="fas fa-trophy"></i>&nbsp;&nbsp;<strong>Level:</strong>&nbsp;&nbsp;${level}</li>
			<li class="list-group-item"><i class="fas fa-fist-raised"></i>&nbsp;&nbsp;<strong>Offense:</strong>&nbsp;&nbsp;${offense}</li>
			<li class="list-group-item"><i class="fas fa-shield-alt"></i>&nbsp;&nbsp;<strong>Defense:</strong>&nbsp;&nbsp;${defense}</li>
		  </ul>
		  <div class="card-body winLoss">
			<span style="float:left;"><i class="fas fa-level-up-alt"></i> Win: <span class="win">${winCount}</span></span>
			<span style="float:right;"><i class="fas fa-level-down-alt"></i> Loss: <span class="loss">${lossCount}</span></span>
		  </div>
		  <div class="card-body owner">
			<div class="left"><strong>Owner:</strong></div>
			<div class="right"><span>${owner}</span></div>
		  </div>
        </li>
		</div>
        `;
    return html;
}