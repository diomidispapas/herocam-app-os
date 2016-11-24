//
//  Observable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

/// An object that has some tear-down logic
public protocol Disposable {
    func dispose()
}

/// An event provides a mechanism for raising notifications, together with some
/// associated data. Multiple function handlers can be added, with each being invoked,
/// with the event data, when the event is raised.
open class Event<T> {
    
    public typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [Invocable]()
    
    public init() {
    }
    
    /// Raises the event, invoking all handlers
    open func raise(_ data: T) {
        for handler in self.eventHandlers {
            handler.invoke(data)
        }
    }
    
    /// Adds the given handler
    @discardableResult open func addHandler<U: AnyObject>(_ target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }
}

// MARK:- Private

// A protocol for a type that can be invoked
private protocol Invocable: class {
    func invoke(_ data: Any)
}

// takes a reference to a handler, as a class method, allowing
// a weak reference to the owning type.
// see: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
private class EventHandlerWrapper<T: AnyObject, U> : Invocable, Disposable {
    weak var target: T?
    let handler: (T) -> (U) -> ()
    let event: Event<U>
    
    init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>){
        self.target = target
        self.handler = handler
        self.event = event;
    }
    
    func invoke(_ data: Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter { $0 !== self }
    }
}

class Observable<T> {
    
    let didChange = Event<(T, T)>()
    fileprivate(set) var value: T
    
    init(_ initialValue: T) {
        value = initialValue
    }
    
    func set(_ newValue: T) {
        let oldValue = value
        value = newValue
        didChange.raise(oldValue, newValue)
    }
    
    func get() -> T {
        return value
    }
}

infix operator <-

func <-<T> (property: Observable<T>, value:  @autoclosure () -> T) {
    property.set(value())
}
