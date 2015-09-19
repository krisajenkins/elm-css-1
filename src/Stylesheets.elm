module Stylesheets where

{-
    Implementation notes:

    - strip out []()""'' - so:
    - toString ["html", "body"] -> "[\"html\",\"body\"]" -> "html,body"

    How would you write this?

    html, body, .foo, .bar
        width: 100%
-}

import String

{- Tags -}

html = Tag "html"
body = Tag "body"
div = Tag "div"
span = Tag "span"
nowrap = Tag "nowrap"
button = Tag "button"
h1 = Tag "h1"
h2 = Tag "h2"
h3 = Tag "h3"
h4 = Tag "h4"
p = Tag "p"
ol = Tag "ol"
input = Tag "input"

tagToString (Tag str) = str


-- TODO these are just for @media - maybe improve type guarantees?
screen = "screen"
print = "print"

-- TODO this is just for ::selection - maybe improve type guarantees?
selection = "selection"


{- Units -}

inheritToString : (a -> String) -> InheritOr a -> String
inheritToString translate value =
    case value of
        Inherit ->
            "inherit"

        NotInherit notInherit ->
            translate notInherit

autoToString : (a -> String) -> AutoOr a -> String
autoToString translate value =
    case value of
        Auto ->
            "auto"

        NotAuto notAuto ->
            translate notAuto

noneToString : (a -> String) -> NoneOr a -> String
noneToString translate value =
    case value of
        None ->
            "none"

        NotNone notNone ->
            translate notNone


unitsToString : Units -> String
unitsToString =
    (\(ExplicitUnits str) -> str)


boxSizingToString : BoxSizing -> String
boxSizingToString =
    (\(ExplicitBoxSizing str) -> str)
        |> inheritToString


overflowToString : Overflow -> String
overflowToString =
    (\(ExplicitOverflow str) -> str)
        |> autoToString
        |> inheritToString


displayToString : Display -> String
displayToString =
    (\(ExplicitDisplay str) -> str)
        |> noneToString
        |> inheritToString


whiteSpaceToString : WhiteSpace -> String
whiteSpaceToString =
    (\(ExplicitWhiteSpace str) -> str)
        |> autoToString
        |> inheritToString

colorToString : Color -> String
colorToString =
    explicitColorToString
        |> autoToString
        |> inheritToString

textShadowToString : TextShadow -> String
textShadowToString =
    explicitTextShadowToString
        |> noneToString
        |> inheritToString


explicitColorToString : ExplicitColor -> String
explicitColorToString value =
    case value of
        RGB r g b ->
            "rgb(" ++ (toString r) ++ ", " ++ (toString g) ++ ", " ++ (toString b) ++ ")"

        RGBA r g b a ->
            "rgba(" ++ (toString r) ++ ", " ++ (toString g) ++ ", " ++ (toString b) ++ ", " ++ (toString a) ++ ")"

        Hex str ->
            "#" ++ str

explicitTextShadowToString : ExplicitTextShadow -> String
explicitTextShadowToString value =
    case value of
        NoTextShadow ->
            "TODO"

outlineStyleToString : OutlineStyle -> String
outlineStyleToString (OutlineStyle str) = str


opacityStyleToString : OpacityStyle -> String
opacityStyleToString (OpacityStyle str) = str


type Tag
    = Tag String

type InheritOr a
    = Inherit
    | NotInherit a

type AutoOr a
    = Auto
    | NotAuto a

type NoneOr a
    = None
    | NotNone a

type alias BoxSizing = InheritOr ExplicitBoxSizing
type alias Overflow = InheritOr (AutoOr ExplicitOverflow)
type alias Display = InheritOr (NoneOr ExplicitDisplay)
type alias WhiteSpace = InheritOr (AutoOr ExplicitWhiteSpace)
type alias Color = InheritOr (AutoOr ExplicitColor)
type alias TextShadow = InheritOr (NoneOr ExplicitTextShadow)
type alias Outline = InheritOr ExplicitOutline

type Units = ExplicitUnits String
type ExplicitBoxSizing = ExplicitBoxSizing String
type ExplicitOverflow = ExplicitOverflow String
type ExplicitDisplay = ExplicitDisplay String
type ExplicitWhiteSpace = ExplicitWhiteSpace String

type ExplicitColor
    = RGB Float Float Float
    | RGBA Float Float Float Float
    | Hex String

type ExplicitOutline
    = ExplicitOutline Float Units OutlineStyle OpacityStyle

type OutlineStyle
    = OutlineStyle String

type OpacityStyle
    = OpacityStyle String

type ExplicitTextShadow
    = NoTextShadow

solid : OutlineStyle
solid = OutlineStyle "solid"

transparent : OpacityStyle
transparent = OpacityStyle "solid"

rgb : number -> number -> number -> Color
rgb r g b =
    RGB r g b |> NotAuto |> NotInherit

rgba : number -> number -> number -> number -> Color
rgba r g b a =
    RGBA r g b a |> NotAuto |> NotInherit

hex : String -> Color
hex str =
    Hex str |> NotAuto |> NotInherit

pct : Units
pct = "%" |> ExplicitUnits

em : Units
em = "em" |> ExplicitUnits

px : Units
px = "px" |> ExplicitUnits

borderBox = "border-box" |> ExplicitBoxSizing |> NotInherit

visible : Display
visible = "visible" |> ExplicitDisplay |> NotNone |> NotInherit

none : InheritOr (NoneOr a)
none = None |> NotInherit

auto : InheritOr (AutoOr a)
auto = Auto |> NotInherit

inherit : InheritOr a
inherit = Inherit

noWrap : WhiteSpace
noWrap = "no-wrap" |> ExplicitWhiteSpace |> NotAuto |> NotInherit


{- Attributes -}

attr1 name translate value =
    Attribute (name ++ ": " ++ (translate value))


attr2 name translateA translateB valueA valueB =
    Attribute (name ++ ": " ++ (translateA valueA) ++ " " ++ (translateB valueB))


attr3 name translateA translateB translateC valueA valueB valueC =
    Attribute (name ++ ": " ++ (translateA valueA) ++ " " ++ (translateB valueB) ++ " " ++ (translateC valueC))


attr4 name translateA translateB translateC translateD valueA valueB valueC valueD =
    Attribute (name ++ ": " ++ (translateA valueA) ++ " " ++ (translateB valueB) ++ " " ++ (translateC valueC) ++ " " ++ (translateD valueD))


attr5 name translateA translateB translateC translateD translateE valueA valueB valueC valueD valueE =
    Attribute (name ++ ": " ++ (translateA valueA) ++ " " ++ (translateB valueB) ++ " " ++ (translateC valueC) ++ " " ++ (translateD valueD) ++ " " ++ (translateE valueE))



display : Display -> Attribute
display =
    attr1 "display" displayToString


width : number -> Units -> Attribute
width =
    attr2 "width" toString unitsToString


minWidth : number -> Units -> Attribute
minWidth =
    attr2 "min-width" toString unitsToString


height : number -> Units -> Attribute
height =
    attr2 "height" toString unitsToString


minHeight : number -> Units -> Attribute
minHeight =
    attr2 "min-height" toString unitsToString


padding : number -> Units -> Attribute
padding =
    attr2 "padding" toString unitsToString


margin : number -> Units -> Attribute
margin =
    attr2 "margin" toString unitsToString


boxSizing : BoxSizing -> Attribute
boxSizing =
    attr1 "box-sizing" boxSizingToString


overflowX : Overflow -> Attribute
overflowX =
    attr1 "overflow-x" overflowToString


overflowY : Overflow -> Attribute
overflowY =
    attr1 "overflow-y" overflowToString


whiteSpace : WhiteSpace -> Attribute
whiteSpace =
    attr1 "white-space" whiteSpaceToString


backgroundColor : Color -> Attribute
backgroundColor =
    attr1 "background-color" colorToString


color : Color -> Attribute
color =
    attr1 "color" colorToString


media : a -> String
media value =
    "media " ++ (toString value)
    -- TODO

textShadow : TextShadow -> Attribute
textShadow =
    attr1 "text-shadow" textShadowToString


outline : Float -> Units -> OutlineStyle -> OpacityStyle -> Attribute
outline =
    attr4 "outline" toString unitsToString outlineStyleToString opacityStyleToString


{- Types -}

type Style class
    = Style String (List Attribute) (List (Style class))


type Attribute
    = Attribute String


stylesheet : Style class
stylesheet =
    Style "" [] []


styleWithPrefix : String -> Style class -> a -> Style class
styleWithPrefix prefix (Style selector attrs children) childSelector =
    children ++ [ Style (prefix ++ (toString childSelector)) [] [] ]
        |> Style selector attrs


(|%|) : Style class -> Tag -> Style class
(|%|) (Style selector attrs children) tag =
    children ++ [ Style (tagToString tag) [] [] ]
        |> Style selector attrs


(|%|...) : Style class -> List Tag -> Style class
(|%|...) (Style selector attrs children) tags =
    let
        childSelector =
            tags
                |> List.map tagToString
                |> String.join " "
    in
        children ++ [ Style childSelector [] [] ]
            |> Style selector attrs


(|@|) : Style class -> a -> Style class
(|@|) = styleWithPrefix "@"


(|::|) : Style class -> a -> Style class
(|::|) = styleWithPrefix "::"


(|>|) : Style class -> a -> Style class
(|>|) = styleWithPrefix ">"


(|.|) : Style class -> class -> Style class
(|.|) = styleWithPrefix "."


(|>.|) : Style class -> a -> Style class
(|>.|) = styleWithPrefix ">."


(|!|) : Style class -> Attribute -> Style class
(|!|) (Style selector attrs children) (Attribute attrString) =
    Style selector (attrs ++ [ (Attribute (attrString ++ " !important")) ]) children


(|-|) : Style class -> Attribute -> Style class
(|-|) (Style selector attrs children) attr =
    Style selector (attrs ++ [ attr ]) children