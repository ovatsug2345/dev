extends Control
const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 2
var SERVER_IP 
var SERVER_PORT
@export var playerScene : PackedScene
var debug = "player"
var thread = null
@export var Level : PackedScene
@export var players = {}
var player_info = {"name": "Name"}
var players_loaded = 0
var min_players = 2
var players_connected = 0
var own_id
var AudioSetup ={}
