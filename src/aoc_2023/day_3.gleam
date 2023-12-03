import gleam/io
import gleam/string
import gleam/list
import gleam/int
import gleam/set
import simplifile

pub fn main() {
  let assert Ok(txt) = simplifile.read("./input/day_3/real.txt")

  txt
  |> part_1
  |> int.to_string
  |> io.println

  txt
  |> part_2
  |> int.to_string
  |> io.println
}

pub type Item {
  Number(inner: Int)
  Period
  Symbol(inner: String)
}

pub type CoordItem {
  CoordItem(coord: List(#(Int, Int)), item: Item)
}

pub fn part_1(input: String) -> Int {
  let grid = parse_grid(input)
  grid
  |> list.filter(is_number)
  |> list.filter(fn(item) {
    list.any(
      get_adj_coords(item),
      fn(c) { list.any(grid, is_symbol_with_coord(_, c)) },
    )
  })
  |> list.map(to_number_unchecked)
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  let grid = parse_grid(input)
  grid
  |> list.filter(is_asterisk)
  |> list.map(fn(ci) {
    let nums =
      grid
      |> list.filter(fn(thingy) {
        ci
        |> get_adj_coords
        |> set.from_list
        |> set.intersection(set.from_list(thingy.coord))
        |> set.size >= 1
      })
      |> list.filter(is_number)

    case list.length(nums) >= 2 {
      True -> {
        nums
        |> list.map(to_number_unchecked)
        |> int.product
      }
      False -> 0
    }
  })
  |> int.sum
}

fn is_symbol_with_coord(item: CoordItem, coord: #(Int, Int)) -> Bool {
  case item {
    CoordItem([t], Symbol(_)) -> t == coord
    _ -> False
  }
}

fn to_number_unchecked(item: CoordItem) -> Int {
  let assert CoordItem(_, Number(n)) = item
  n
}

fn is_number(input: CoordItem) -> Bool {
  case input.item {
    Number(_) -> True
    _ -> False
  }
}

fn is_asterisk(input: CoordItem) -> Bool {
  case input.item {
    Symbol("*") -> True
    _ -> False
  }
}

fn get_adj_coords(input: CoordItem) -> List(#(Int, Int)) {
  input.coord
  |> list.map(adj_coords)
  |> list.flatten
}

fn adj_coords(coord: #(Int, Int)) -> List(#(Int, Int)) {
  let #(x, y) = coord
  [
    #(x - 1, y - 1),
    #(x, y - 1),
    #(x + 1, y - 1),
    #(x - 1, y),
    #(x + 1, y),
    #(x - 1, y + 1),
    #(x, y + 1),
    #(x + 1, y + 1),
  ]
  |> list.filter(fn(coord) {
    let #(x, y) = coord
    x >= 0 && y >= 0
  })
}

fn parse_grid(input: String) -> List(CoordItem) {
  let lines = string.split(input, "\n")
  list.index_fold(
    lines,
    [],
    fn(acc, line, x_coord) {
      let row =
        list.index_fold(
          string.to_graphemes(line),
          [],
          fn(acc, char, y_coord) {
            case char {
              "." -> [CoordItem([#(x_coord, y_coord)], Period), ..acc]
              x -> {
                case int.parse(x) {
                  Error(_) -> [
                    CoordItem([#(x_coord, y_coord)], Symbol(x)),
                    ..acc
                  ]
                  Ok(n) -> {
                    case acc {
                      [CoordItem(coords, Number(num)), ..rest] -> {
                        let assert Ok(num) = int.digits(num, 10)
                        let assert Ok(thing) =
                          int.undigits(list.append(num, [n]), 10)
                        [
                          CoordItem(
                            [#(x_coord, y_coord), ..coords],
                            Number(thing),
                          ),
                          ..rest
                        ]
                      }
                      _ -> [CoordItem([#(x_coord, y_coord)], Number(n)), ..acc]
                    }
                  }
                }
              }
            }
          },
        )
      [row, ..acc]
    },
  )
  |> list.flatten
}
