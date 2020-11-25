import Foundation

class ConsoleSpiral {
    typealias DecartSystem = [[PointType]]
    
    private struct Constants {
        static let width = 90
        static let height = 140
        static let incrementAngle = 0.009
        static let incrementLenght = 0.02
    }
    
    enum PointType: String {
        case filled = " "
        case empty = "*"
        
        func stringRepresentation(reverse: Bool = false) -> String {
            switch self {
                case .filled:
                    let result: Self = reverse ? .filled : .empty
                    return result.rawValue
                case .empty:
                    let result: Self = reverse ? .empty : .filled
                    return result.rawValue
            }
        }
    }
    
    struct Point: Comparable {
        var x: Double
        var y: Double
        
        func round() -> Point {
            let newX = floor((x.rounded() + Double(Constants.width)) / 2.0)
            let newY = floor((y.rounded() + Double(Constants.height)) / 2.0)
            
            return Point(x: newX, y: newY)
        }
        
        static func < (lhs: Self, rhs: Self) -> Bool {
            Int(lhs.x) < Int(rhs.x) && Int(lhs.y) < Int(rhs.y)
        }
        
        static func zero() -> Self {
            Point(x: 0, y: 0)
        }
        
        static func max() -> Self {
            Point(
                x: Double(Constants.width - 1),
                y: Double(Constants.height - 1)
            )
        }
    }
    
    lazy var coordinates: [[PointType]] = {
        Array(
            repeating:
                Array(repeating: PointType.empty, count: Constants.height),
            count: Constants.width
        )
    }()
    
    var isReversed: Bool = false
    
    func calculate(
        startAngle: Double = 0.0,
        startLenght: Double = 0.0
    ) {
        var angle: Double = startAngle
        var lenght: Double = startLenght
                
        while true {
            let x = cos(angle) * lenght
            let y = sin(angle) * lenght
            
            let point = Point(x: x, y: y)
            guard calculatePoint(point) else { break }
            
            angle += Constants.incrementAngle
            lenght += Constants.incrementLenght
        }
    }
}

private extension ConsoleSpiral {
    @discardableResult
    func calculatePoint(_ point: Point) -> Bool {
        let rounded = point.round()
        guard rounded > .zero(), rounded < .max() else { return false }
        
        coordinates[rounded.x.toInt()][rounded.y.toInt()] = .filled
        return true
    }
    
    func draw() {
        coordinates.forEach { row in
            row.forEach { field in
                print(field.stringRepresentation(reverse: isReversed), separator: "", terminator: "")
            }
            print()
        }
    }
}

extension Double {
    func toInt() -> Int {
        Int(self)
    }
}

let spiralDriver = ConsoleSpiral()

// uncomment it
//spiralDriver.isReversed = true
spiralDriver.calculate()
spiralDriver.draw()
