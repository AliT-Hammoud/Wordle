//
//  ViewController.swift
//  Wordle
//
//  Created by Ali Hammoud on 11/03/2022.
//

import UIKit
// UI
// Keyboard
// Game board
// orange/ green

class ViewController: UIViewController {
    
    let answers = ["after", "later", "bloke", "there","ultra"]
    
    private var answer = "after"
    private var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5),
                                        count: 6)
    private let keyBoardVC = KeyboardViewController()
    private let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "after"
        view.backgroundColor = .systemGray6
        addChildren()
    }

    
    private func addChildren() {
        addChild(keyBoardVC)
        keyBoardVC.delegate = self
        keyBoardVC.didMove(toParent: self)
        keyBoardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyBoardVC.view)
        
        
        addChild(boardVC)
        boardVC.dataSource = self
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyBoardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            keyBoardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyBoardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyBoardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        var stop = false
        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        
        boardVC.reloadData()
    }
}

extension ViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        let count = guesses[rowIndex].compactMap({$0}).count
        guard count == 5 else {
            return nil
        }
        let indexedAnswer = Array(answer)
        guard let letter = guesses[indexPath.section][indexPath.row], indexedAnswer.contains(letter) else {return nil}
        
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        
        return .systemOrange
    }
}
