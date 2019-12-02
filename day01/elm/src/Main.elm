module Main exposing (Msg)

import Ports exposing (print)
import Task


type alias Flags =
    { input : String }


type alias Model =
    { fuelRequired : Maybe Int }


type alias ModuleMass =
    Int


type Msg
    = NoOp
    | ProcessModulesMasses (List ModuleMass)
    | ProcessModulesMasses2 (List ModuleMass)
    | Print String


execute : Msg -> Cmd Msg
execute msg =
    Task.perform identity (Task.succeed <| msg)


recursiveFuelMass : Int -> Int
recursiveFuelMass fuelMass =
    let
        fuelForFuelMass =
            fuelMass // 3 - 2
    in
    if fuelForFuelMass <= 0 then
        0

    else
        fuelForFuelMass + recursiveFuelMass fuelForFuelMass


processModulesMasses2 : Model -> List ModuleMass -> ( Model, Cmd Msg )
processModulesMasses2 model modulesMasses =
    let
        fuelRequiredPerModule moduleMass =
            let
                moduleFuel =
                    (moduleMass // 3) - 2
            in
            moduleFuel + recursiveFuelMass moduleFuel

        fuelRequired =
            modulesMasses
                |> List.map fuelRequiredPerModule
                |> List.foldl (+) 0

        newModel =
            { model | fuelRequired = Just fuelRequired }
    in
    ( newModel
    , execute <|
        Print <|
            "fuelRequired 2 "
                ++ String.fromInt fuelRequired
    )


processModulesMasses : Model -> List ModuleMass -> ( Model, Cmd Msg )
processModulesMasses model modulesMasses =
    let
        fuelRequiredPerModule moduleMass =
            (moduleMass // 3) - 2

        fuelRequired =
            modulesMasses
                |> List.map fuelRequiredPerModule
                |> List.foldl (+) 0

        newModel =
            { model | fuelRequired = Just fuelRequired }
    in
    ( newModel
    , execute <|
        Print <|
            "fuelRequired "
                ++ String.fromInt fuelRequired
    )


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        modules : List ModuleMass
        modules =
            flags.input
                |> String.split "\n"
                |> List.filterMap String.toInt

        model =
            { fuelRequired = Nothing }
    in
    ( model
    , Cmd.batch
        [ execute <| ProcessModulesMasses2 modules
        , execute <| ProcessModulesMasses modules
        , execute <| ProcessModulesMasses2 [ 100756 ]
        , execute <| ProcessModulesMasses [ 100756 ]
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ProcessModulesMasses modulesMasses ->
            processModulesMasses model modulesMasses

        ProcessModulesMasses2 modulesMasses ->
            processModulesMasses2 model modulesMasses

        Print string ->
            ( model, print string )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
