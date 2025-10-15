///|
priv struct LinearScanKNN[Point] {
  dimension : Int
  points : Array[Point]
}

///|
fn[T] LinearScanKNN::new(
  dimension : Int,
  points? : Array[T] = [],
) -> LinearScanKNN[T] {
  LinearScanKNN::{ dimension, points }
}

///|
fn[T] LinearScanKNN::add(self : LinearScanKNN[T], point : T) -> Unit {
  self.points.push(point)
}

///|
fn[T : Point + Eq + Compare] LinearScanKNN::search_by(
  self : LinearScanKNN[T],
  point : T,
  n : Int,
) -> Array[T] {
  // squared Euclidean distance
  fn dist(x : T, y : T) -> UInt64 {
    let x = x.to_fixedarray()
    let y = y.to_fixedarray()
    let mut sum = 0UL
    for i in 0..<self.dimension {
      // avoid overflow
      let diff = (x[i] - y[i]).to_int64().abs().reinterpret_as_uint64()
      sum += diff * diff
    }
    return sum
  }

  // Use a max-heap to maintain the k closest points
  // The heap stores (distance, point) pairs
  let heap = @priority_queue.new()
  for candidate_point in self.points {
    let distance = dist(point, candidate_point)
    if heap.length() < n {
      // If heap is not full, add the point
      heap.push((distance, candidate_point))
    } else {
      // If heap is full, check if current point is closer than the farthest
      match heap.peek() {
        Some((max_distance, _)) =>
          if distance < max_distance {
            // Remove the farthest point and add the current one
            ignore(heap.pop())
            heap.push((distance, candidate_point))
          }
        None => ()
      }
    }
  }

  // Extract points from heap and return them
  let result = Array::new()
  while not(heap.is_empty()) {
    match heap.pop() {
      Some((_, p)) => result.push(p)
      None => break
    }
  }

  // The result is in reverse order (farthest to closest), so reverse it manually
  let length = result.length()
  for i in 0..<(length / 2) {
    let temp = result[i]
    result[i] = result[length - 1 - i]
    result[length - 1 - i] = temp
  }
  return result
}

///|
test {
  let points = [
    (1, 0),
    (0, 1),
    (-1, 0),
    (0, -1),
    (1, 1),
    (-1, -2),
    (2, 2),
    (-2, -3),
  ]
  let knn = LinearScanKNN::new(2, points~)
  @json.inspect(knn.search_by((0, 0), 4), content=[
    [-1, 0],
    [0, -1],
    [0, 1],
    [1, 0],
  ])
  @json.inspect(knn.search_by((0, 0), 5), content=[
    [-1, 0],
    [0, -1],
    [0, 1],
    [1, 0],
    [1, 1],
  ])
  @json.inspect(knn.search_by((0, 0), 6), content=[
    [-1, 0],
    [0, -1],
    [0, 1],
    [1, 0],
    [1, 1],
    [-1, -2],
  ])
  @json.inspect(knn.search_by((1, 1), 4), content=[
    [1, 1],
    [0, 1],
    [1, 0],
    [2, 2],
  ])
}
