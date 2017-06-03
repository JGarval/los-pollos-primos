//
//  GameScene.swift
//  lospollosprimos
//
//  Created by Javier García Valdepeñas on 12/5/15.
//  Copyright (c) 2015 Javier García Valdepeñas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Sprites que se formarán con texturas
    var chick = SKSpriteNode()
    var egg = SKSpriteNode()
    var bg = SKSpriteNode()
    
    // Nodo padre de los objetos que se mueven (chick y egg)
    var movingObjects = SKNode()
    
    // Variable que contendrá un timer
    var timer = NSTimer()
    
    // El nivel de dificultad medido en huevos cascados
    let nivel = 5
    
    // Iniciamos gameOver a cero para representar que se está jugando
    var gameOver = 0
    
    // Creamos una etiqueta que mostrará la puntuación y su padre
    var scoreLabel = SKLabelNode()
    var scoreHolder = SKSpriteNode()
    
    // Creamos una etiqueta que mostrará el fin del juego y su padre
    var gameOverLabel = SKLabelNode()
    var gameOverHolder = SKSpriteNode()
    
    // Contador de huevos cascados
    // @Definicion: Cuando los huevos cascados == nivel de dificultad => fin del juego
    var Contador: Int = 0 {
        didSet {
            if Contador == nivel {
                gameOver = 1
                movingObjects.speed = 0
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 60
                gameOverLabel.text = "Well Done! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100)
                gameOverLabel.zPosition = 30
                gameOverHolder.addChild(gameOverLabel)
                scoreHolder.removeAllChildren()
            }
        }
    }
    
    // Variable que contiene los movimientos del eje X de los objetos que se mueven
    var moveX: SKAction {
        return SKAction.moveByX(-10 , y: 0, duration: 0.07)
    }
    
    // Variable que contiene la posición de partida de los objetos que se mueven
    var positionObjects: CGPoint {
        return CGPoint(x: CGRectGetMaxX(self.frame) , y: CGRectGetMaxY(self.frame) / 3)
    }
    
    
    // Añadido: accion contraria a moveX
    var moveX1: SKAction {
        return SKAction.moveByX(10 , y: 0, duration: 0.07)
    }
    
    // Añadido: se añade otro nodo padre de objetos que se mueven
    var positionObjects1: CGPoint {
        return CGPoint(x: CGRectGetMinX(self.frame) , y: CGRectGetMaxY(self.frame) / 2)
    }
    
    override func didMoveToView(view: SKView) {
        // Añadimos los objetos padres
        self.addChild(movingObjects)
        self.addChild(scoreHolder)
        self.addChild(gameOverHolder)
        
        // Creamos el fondo y la puntuación
        makeBg()
        makeScore()
        
        // Se ejecutará esto si se está jugando
        if gameOver == 0 {
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("makeChick"), userInfo: nil, repeats: true)
            timer = NSTimer.scheduledTimerWithTimeInterval(4.5, target: self, selector: Selector("makeEgg"), userInfo: nil, repeats: true)
            
            // Añadido
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("makeOtherChick"), userInfo: nil, repeats: true)
            timer = NSTimer.scheduledTimerWithTimeInterval(4.5, target: self, selector: Selector("makeOtherEgg"), userInfo: nil, repeats: true)
        }
    }
    
    // Función que pinta la puntuación
    func makeScore() {
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 100
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame) , y: CGRectGetMidY(self.frame) + 100)
        scoreLabel.zPosition = 23
      
        scoreHolder.addChild(scoreLabel)
    }
    
    // Función que pinta el fondo
    func makeBg() {
        var bgTexture = SKTexture(imageNamed: "img/bg.png")
        bg = SKSpriteNode(texture: bgTexture)
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bg.size.height = self.frame.height
        bg.size.width = self.frame.width
       
        self.addChild(bg)
    }
    
    // Función que hace mover la cinta
    func moveBg() {
        var bgTexture = SKTexture(imageNamed: "img/bg.png")
        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(movebgForever)
            movingObjects.addChild(bg)
        }
    }
    
    // Función que pinta el pollo
    func makeChick() -> SKAction {
        var chickTextureUp = SKTexture(imageNamed: "img/chickenup.png")
        var chickTextureDown = SKTexture(imageNamed: "img/chickendown.png")
        var chickUpDown = SKAction.animateWithTextures([chickTextureUp, chickTextureDown], timePerFrame: 0.5)
        var makeChickFlap = SKAction.repeatActionForever(chickUpDown)
        var moveChickHorizontal = moveX
        var moveChickForever = SKAction.repeatActionForever(moveChickHorizontal)
        chick = SKSpriteNode(texture: chickTextureUp)
        chick.name = "Pollo"
        chick.position = positionObjects
        chick.runAction(makeChickFlap)
        chick.zPosition = 21
        chick.runAction(moveChickForever)
        
        movingObjects.addChild(chick)
        
        return moveChickForever
    }

    // Añadido: Función 2 que pinta el pollo
    func makeOtherChick() -> SKAction {
        var chickTextureUp = SKTexture(imageNamed: "img/chickenup1.png")
        var chickTextureDown = SKTexture(imageNamed: "img/chickendown1.png")
        var chickUpDown = SKAction.animateWithTextures([chickTextureUp, chickTextureDown], timePerFrame: 0.5)
        var makeChickFlap = SKAction.repeatActionForever(chickUpDown)
        var moveChickHorizontal = moveX1
        var moveChickForever = SKAction.repeatActionForever(moveChickHorizontal)
        chick = SKSpriteNode(texture: chickTextureUp)
        chick.name = "Pollo"
        chick.position = positionObjects1
        chick.runAction(makeChickFlap)
        chick.zPosition = 21
        chick.runAction(moveChickForever)
        
        movingObjects.addChild(chick)
        
        return moveChickForever
    }
    
    // Función que pinta el huevo
    func makeEgg() -> SKAction {
        var eggTexture = SKTexture(imageNamed: "img/huevo.png")
        var eggRightTexture = SKTexture(imageNamed: "img/huevoright.png")
        var animationEgg = SKAction.animateWithTextures([eggTexture, eggRightTexture], timePerFrame: 0.5)
        var moveEgg = SKAction.repeatActionForever(animationEgg)
        var moveEggs = moveX
        var moveEggsForever = SKAction.repeatActionForever(moveEggs)
        egg = SKSpriteNode(texture: eggTexture)
        egg.name = "Huevo"
        egg.position = positionObjects
        egg.zPosition = 22
        egg.runAction(moveEgg)
        egg.runAction(moveEggsForever)
       
        movingObjects.addChild(egg)
        
        return moveEggsForever
    }
    
    // Añadido: Otra función contraria que crea huevos
    func makeOtherEgg() -> SKAction {
        var eggTexture = SKTexture(imageNamed: "img/huevo.png")
        var eggRightTexture = SKTexture(imageNamed: "img/huevoright.png")
        var animationEgg = SKAction.animateWithTextures([eggTexture, eggRightTexture], timePerFrame: 0.5)
        var moveEgg = SKAction.repeatActionForever(animationEgg)
        var moveEggs = moveX1
        var moveEggsForever = SKAction.repeatActionForever(moveEggs)
        egg = SKSpriteNode(texture: eggTexture)
        egg.name = "Huevo"
        egg.position = positionObjects1
        egg.zPosition = 22
        egg.runAction(moveEgg)
        egg.runAction(moveEggsForever)
        
        movingObjects.addChild(egg)
        
        return moveEggsForever
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Cuando se esté jugando y se pulse la pantalla se localizará qué objeto se ha pulsado
        // Si es un huevo se le aplicará el cambio pertinente para que "nazca" un pollito
        if gameOver == 0 {
            if let toque = touches.first as? UITouch {
                let sprite = self.nodeAtPoint(toque.locationInNode(self))
                if sprite.name == "Huevo" {
                    sprite.name = "Pollo"
                    var chickTextureDown = SKTexture(imageNamed: "img/chickenUp.png")
                    var chickTextureUp = SKTexture(imageNamed: "img/chickenDown.png")
                    var chickUpDown = SKAction.animateWithTextures([chickTextureDown, chickTextureUp], timePerFrame: 0.5)
                    var makeChickFlap = SKAction.repeatActionForever(chickUpDown)
                    sprite.runAction(makeChickFlap)
                    Contador++
                    scoreLabel.text = "\(Contador)"
                }
            }
        } else {
            // Cuando el juego finaliza ponemos todo a 0 y borramos los hijos
            Contador = 0
            scoreLabel.text = "0"
            movingObjects.removeAllChildren()
            makeBg()
            gameOver = 0
            movingObjects.speed = 1
            makeScore()
            gameOverHolder.removeAllChildren()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {}
}
