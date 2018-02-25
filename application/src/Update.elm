module Update exposing (..)



import Msgs exposing (Msg)
import Models exposing (Model, Player)
import Routing exposing (parseLocation)
import Commands exposing (savePlayerCmd, deletePlayerCmd, loadPlayerList)
import RemoteData
import Navigation exposing (load)



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        
        Msgs.OnLocationChange location ->
            let 
                newRoute =
                    parseLocation location
            

            in
                ( { model | route = newRoute }, Cmd.none )
        

        Msgs.ChangeLevel player howMuch ->
            let
                updatedPlayer = 
                    { player | level = player.level + howMuch }
            in
                ( model, savePlayerCmd updatedPlayer )
        


        Msgs.OnPlayerSave (Ok player) ->
            ( updatePlayer model player, Cmd.none )



        Msgs.OnPlayerSave (Err error) ->
            ( model, Cmd.none )
        

        Msgs.DeletePlayer player ->
            ( model, deletePlayerCmd player )



        Msgs.OnPlayerDelete (Ok player) ->
            ( deletePlayer model player, load "http://localhost:3000/players" )



        Msgs.OnPlayerDelete (Err error) ->
            ( model, Cmd.none )




updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer
            else
                currentPlayer
        
        updatePlayerList players =
            List.map pick players
        
        updatedPlayers =
            RemoteData.map updatePlayerList model.players
    in
        { model | players = updatedPlayers }



deletePlayer : Model -> Player -> Model
deletePlayer model player =
    let
        -- pick currentPlayer =
        --     if player.id /= currentPlayer.id then
        --         currentPlayer
        
        updatePlayerList players =
            List.filter (\p -> player.id /= p.id) players
        
        updatedPlayers =
            RemoteData.map updatePlayerList model.players
    in
        { model | players = updatedPlayers }