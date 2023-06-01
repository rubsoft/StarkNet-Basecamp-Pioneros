struct Auto {
    marca: String,
    modelo: String,
    year: u256,
    numeroPlaca: String
}

struct Papeleta {
    ipfsCID: String,
    autoInfo: Auto
}

struct Storage {
    hasPapeleta: Map<Address, felt>,
    papeletas: Map<u256, Papeleta>
}

contract PapeletaControl is ERC20 {
    storage: Storage

    constructor(name: String, symbol: String) ERC20(name, symbol) {
        storage.hasPapeleta := {}
        storage.papeletas := {}
    }

    function agregarPapeleta(string memory ipfsCID, string memory marca, string memory modelo, uint256 year, string memory numeroPlaca) external {
        require(storage.hasPapeleta[msg.sender] == 0, "Ya tienes una papeleta");

        uint256 tokenId = totalSupply() + 1;
        _mint(msg.sender, tokenId);
        storage.hasPapeleta[msg.sender] := tokenId;

        Auto memory autoData = Auto(marca, modelo, year, numeroPlaca);
        storage.papeletas[tokenId] = Papeleta(ipfsCID, autoData);
    }

    function pagarPapeleta() external {
        require(storage.hasPapeleta[msg.sender] != 0, "No tienes una papeleta pendiente");

        uint256 tokenId = storage.hasPapeleta[msg.sender];
        _burn(msg.sender, tokenId);
        storage.hasPapeleta[msg.sender] := 0;
    }
}
