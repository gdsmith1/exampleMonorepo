package go_unit_test_bootcamp

func FindMissingDrone(droneIds []int) int {
    uniqueId := 0
    for _, id := range droneIds {
        uniqueId ^= id
    }
    return uniqueId
}