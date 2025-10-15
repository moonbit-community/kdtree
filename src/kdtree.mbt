///|
pub struct KDTree {
  point : Point
  partition_axis : Int
  left : KDTree?
  right : KDTree?
}

///|

///|
pub fn KDTree::is_leaf(self : KDTree) -> Bool {
  return self.left is None && self.right is None && self.partition_axis == -1
}

///|
pub fn KDTree::singleton(point : Point) -> KDTree {
  return KDTree::{
    point,
    partition_axis: -1, // No partition axis for a singleton
    left: None,
    right: None,
  }
}

///|
fn[T] KDTree::partition_by(
  arr : Array[T],
  get_key : (T) -> Int,
  start~ : Int,
  end~ : Int,
) -> Int {
  let lo = start
  let hi = end - 1
  let pivot = get_key(arr[hi])
  let mut i = lo - 1
  for j in lo..<hi {
    if get_key(arr[j]) <= pivot {
      i += 1
      arr.swap(i, j)
    }
  }
  arr.swap(i + 1, hi)
  return i + 1
}

///|
/// select the k-th smallest element in the arr
fn[T] KDTree::quickselect_by(
  arr : Array[T],
  start~ : Int,
  end~ : Int,
  k : Int,
  get_key : (T) -> Int,
) -> T {
  if end - start == 1 {
    return arr[start]
  }
  let pivot_index = KDTree::partition_by(arr, get_key, start~, end~)
  if k == pivot_index {
    return arr[k]
  } else if k < pivot_index {
    return KDTree::quickselect_by(arr, start~, end=pivot_index, k, get_key)
  } else {
    return KDTree::quickselect_by(arr, start=pivot_index + 1, end~, k, get_key)
  }
}

///|
test "select k-th smallest element" {
  let id = x => x
  let arr = [1, 1, 2, 3, 3, 5, 6, 7, 8, 9]
  inspect(
    KDTree::quickselect_by(arr, 0, id, start=0, end=arr.length()),
    content="1",
  )
  inspect(
    KDTree::quickselect_by(arr, 1, id, start=0, end=arr.length()),
    content="1",
  )
  inspect(
    KDTree::quickselect_by(arr, 2, id, start=0, end=arr.length()),
    content="2",
  )
  inspect(
    KDTree::quickselect_by(arr, 3, id, start=0, end=arr.length()),
    content="3",
  )
  inspect(
    KDTree::quickselect_by(arr, 4, id, start=0, end=arr.length()),
    content="3",
  )
  inspect(
    KDTree::quickselect_by(arr, 5, id, start=0, end=arr.length()),
    content="5",
  )
  let arr2 = [0]
  inspect(
    KDTree::quickselect_by(arr2, 0, id, start=0, end=arr2.length()),
    content="0",
  )
}

///|
fn[T] KDTree::split_by_midvalue(
  arr : Array[T],
  get_key : (T) -> Int,
  start~ : Int,
  end~ : Int,
) -> ((Int, Int), T, (Int, Int)) {
  // TODO: BFPRT https://en.wikipedia.org/wiki/Median_of_medians
  let mid = (end - start) / 2
  ignore(KDTree::quickselect_by(arr, mid, get_key, start~, end~))
  ((start, mid), arr[mid], (mid + 1, end))
}

///|
test "split by midvalue" {
  let id = x => x
  let arr = [1, 2, 3, 4, 5]
  let (left, mid, right) = KDTree::split_by_midvalue(
    arr,
    id,
    start=0,
    end=arr.length(),
  )
  inspect(arr[left.0:left.1], content="[1, 2]")
  inspect(mid, content="3")
  inspect(arr[right.0:right.1], content="[4, 5]")
  let arr2 = [1]
  let (left2, mid2, right2) = KDTree::split_by_midvalue(
    arr2,
    id,
    start=0,
    end=arr2.length(),
  )
  inspect(arr2[left2.0:left2.1], content="[]")
  inspect(mid2, content="1")
  inspect(arr2[right2.0:right2.1], content="[]")
  let arr3 = [1, 2, 2, 3, 4]
  let (left3, mid3, right3) = KDTree::split_by_midvalue(
    arr3,
    id,
    start=0,
    end=arr3.length(),
  )
  inspect(arr3[left3.0:left3.1], content="[1, 2]")
  inspect(mid3, content="2")
  inspect(arr3[right3.0:right3.1], content="[3, 4]")
  let arr4 = [1, 2, 3, 3, 4]
  let (left4, mid4, right4) = KDTree::split_by_midvalue(
    arr4,
    id,
    start=0,
    end=arr4.length(),
  )
  inspect(arr4[left4.0:left4.1], content="[1, 2]")
  inspect(mid4, content="3")
  inspect(arr4[right4.0:right4.1], content="[3, 4]")
  let arr5 = [1, 2, 3, 4, 5, 6]
  let (left5, mid5, right5) = KDTree::split_by_midvalue(
    arr5,
    id,
    start=0,
    end=arr5.length(),
  )
  inspect(arr5[left5.0:left5.1], content="[1, 2, 3]")
  inspect(mid5, content="4")
  inspect(arr5[right5.0:right5.1], content="[5, 6]")
}

///|
pub fn KDTree::from(points : Array[Point], k : Int) -> KDTree {
  fn go(points : Array[Point], depth : Int, start : Int, end : Int) -> KDTree? {
    if end - start == 0 {
      return None
    } else {
      let axis = depth % k
      let (left, point, right) = KDTree::split_by_midvalue(
        points,
        p => p[axis],
        start~,
        end~,
      )
      let left = go(points, depth + 1, left.0, left.1)
      let right = go(points, depth + 1, right.0, right.1)
      return Some(KDTree::{ point, partition_axis: axis, left, right })
    }
  }

  guard go(points, 0, 0, points.length()) is Some(tree)
  return tree
}
