function stage2_load()
	world_2 = love.physics.newWorld(0, 5*64, true)
	objects = {}
	---------------------------------platform--------------------------------------------
	objects.platform_right = {}
	objects.platform_right.body = love.physics.newBody(world_2, 100,(height*3/4))
	objects.platform_right.shape = love.physics.newRectangleShape(300, 50)
	objects.platform_right.fixture = love.physics.newFixture(objects.platform_right.body, objects.platform_right.shape)
	--------------------------------ball--------------------------------------------------
	x_stage_play_button= 15
	y_stage_play_button= 50

	x_stage_replay_button = x_stage_play_button 
	y_stage_replay_button = y_stage_play_button + 74

	x_stage_help_button =  x_stage_play_button 
	y_stage_help_button = height - 75


	objects.ball = {}
	objects.ball.body = love.physics.newBody(world_2, 210,(height*3/4)-47, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(21)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape)
	x_ball, y_ball = objects.ball.body:getX(), objects.ball.body:getY()
	objects.ball.body:setActive( false )

	x_arrow_right =  x_ball + 40
	y_arrow_right =  y_ball - 35


	rotation = math.pi
	stage_play = true --controle
	stage_replay=true -- controle
	stage_help = true
	help = false
	-------------------------line---------------------------------------------------------
	mouse_positions = {}
	size = 4,5
	width_line = -100
	height_line = -100
	draw= true
	--line
	objects.line={}
	objects.line.body = love.physics.newBody(world_2, width_line, height_line)
	objects.line.shape = love.physics.newCircleShape(size)
	objects.line.fixture = love.physics.newFixture(objects.line.body, objects.line.shape)
	-----------------------flag---------------------------------------------------------
	x_flag=width-130
	y_flag=1/6*height - 50
	passou= false
	fail=false
	------------------------------speed booster------------------------------------
	x_booster_1= x_flag - 330
	y_booster_1= y_flag + 200

	x_booster_2= width/2 - 300
	y_booster_2= height /2 + 70

	------------------------stars------------------------------------------------------
	score= 0
	x_star1= x_booster_1 + 32 +100
	y_star1= y_booster_1 - 25
	star_1_collision = false

	x_star2= width/2
	y_star2= height/2 - 250
	star_2_collision = false

	x_star3= x_booster_2 +32 +100
	y_star3= y_booster_2 - 25
	star_3_collision = false
	stars={}
	for i=1,4 do
		stars[i]=0
	end
	--para o efeito da pontuacao
	x_score_1=x_star1
	y_score_1=y_star1
	x_score_2=x_star2
	y_score_2=y_star2
	x_score_3=x_star3
	y_score_3=y_star3
	opacity1 = 255
	opacity2 = 255
	opacity3 = 255
end
function stage2_update(dt)
	world_2:update(dt)
	x, y = love.mouse.getPosition( )
	--------------------------flag--------------------------------------

	if objects.ball.body:getY() > 950 then
		fail = true
	end

	if checaToqueRectangle(objects.ball.body:getX(),objects.ball.body:getY(), x_flag, y_flag, 84, 128) then
		passou= true
		final_score  = total_score
		objects.ball.body:setActive( false )
	end


	------------------------line-----------------------------------------

	if draw then
		love.mouse.setVisible( false )
	end
	if checaToqueRectangle(x_mouse,y_mouse, x_stage_play_button, y_stage_play_button, 64, 64) then
		love.mouse.setVisible( true )
	end
	color_black = {0, 0, 0}
	down = love.mouse.isDown(1)

	if down and draw then
		mouse_positions[#mouse_positions + 1] = {color_black, x, y, size}
		width_line = x
		height_line = y
		objects.line={}
		objects.line.body = love.physics.newBody(world_2, width_line, height_line)
		objects.line.shape = love.physics.newCircleShape(size)
		objects.line.fixture = love.physics.newFixture(objects.line.body, objects.line.shape)
	end
	------------------------ball--------------------------------------------
	velocX_bola, velocY_bola = objects.ball.body:getLinearVelocity( )
	x_ball, y_ball = objects.ball.body:getX(), objects.ball.body:getY()
	if  not((passou and  fail) and  next_menu_active) then
		if checaToqueRectangle(x_mouse, y_mouse, -10, -10 , 100 , height+10 ) then 
			love.mouse.setVisible( true )
			draw = false
		elseif stage_play then 
			draw = true
		end
		if checarToqueCircle(x_mouse, y_mouse, x_stage_play_button+32, y_stage_play_button+32, 32 ) then
			love.mouse.setVisible( true )
			if love.mouse.isDown(1) and stage_play and not passou and  not fail then
				objects.ball.body:applyForce(8000, 0)
				objects.ball.body:setActive( true )
				stage_play=false
				draw= false
			end
		end

		if checarToqueCircle(x_mouse, y_mouse, x_stage_replay_button+32, y_stage_replay_button+32, 32 ) then
			love.mouse.setVisible(true)
			if love.mouse.isDown(1) and stage_replay and not passou and  not fail then
				world_2:destroy( )
				stage2_load()
				score_update = true
			end
		end

		if checarToqueCircle(x_mouse, y_mouse, x_stage_help_button+32, y_stage_help_button+32, 32 ) then
			love.mouse.setVisible(true)
			if love.mouse.isDown(1) and stage_help and not passou and  not fail and stage_play then
				help = true
				stage_help = false
				stage_play=false
				draw = false
			end
		end
		if love.keyboard.isDown("escape") and help and not stage_help then
			help = false
			stage_help = true
			draw = true
			stage_play=true
		end

		if not passou then
			rotation=rotation+velocX_bola/1000
		end
	end
	-----------------------------booster---------------------------------------
	if (checaToqueRectangle(x_ball, y_ball, x_booster_1, y_booster_1, 64, 64) or checaToqueRectangle(x_ball, y_ball, x_booster_2, y_booster_2, 64, 64)) and not booster_active then
		objects.ball.body:applyForce(1500, 0)
	end

	-----------------------------score------------------------------------------

	if checaToqueRectangle(objects.ball.body:getX(),objects.ball.body:getY(), x_star1-15, y_star1-15, 60, 60) and not star_1_collision then
		stars[1]= 100
		star_1_collision = true
		y_score_1 = y_star1
		opacity1=255
		score_update = true
	end
	y_score_1 = y_score_1 -4
	opacity1 = opacity1 -10

	if checaToqueRectangle(objects.ball.body:getX(),objects.ball.body:getY(), x_star2-15, y_star2-15, 60, 60) and not star_2_collision then
		stars[2]= 100
		star_2_collision = true
		y_score_2 = y_star2
		opacity2 = 255
		score_update = true
	end
	y_score_2 = y_score_2 -4
	opacity2 = opacity2 -10

	if checaToqueRectangle(objects.ball.body:getX(),objects.ball.body:getY(), x_star3-15, y_star3-15, 60, 60) and not star_3_collision then
		stars[3]=100
		star_3_collision = true
		y_score_3 = y_star3
		opacity3 = 255
		score_update = true
	end
	y_score_3 = y_score_3 -4
	opacity3 = opacity3 -10

	if stars[1] == 100 and stars[2]== 0 and stars[3]== 0 then
		stars[4]= 0
	elseif stars[1] == 0 and stars[2]== 100 and stars[3]== 0 then
		stars[4]= 0
	elseif stars[1] == 0 and stars[2]== 0 and stars[3]== 100 then
		stars[4]= 0
	elseif stars[1] == 100 and stars[2]== 100 and stars[3]== 0 then
		stars[4]= 50
	elseif stars[1] == 100 and stars[2]== 0 and stars[3]== 100 then
		stars[4]= 50
	elseif stars[1] == 0 and stars[2]== 100 and stars[3]== 100 then
		stars[4]= 50
	elseif stars[1] == 100 and stars[2]== 100 and stars[3]== 100 then
		stars[4]= 150
	end
	score = stars[1] + stars[2] + stars[3] + stars[4]
end

function stage2_draw()
	love.graphics.setColor(0, 0, 0)
   	love.graphics.setFont(font_low)
	-------------------------------flag--------------------------------------

	love.graphics.setColor(255,255,255)
	love.graphics.draw(flag, x_flag, y_flag)

-------------------------------line------------------------------------

	for i = 1, #mouse_positions do
		obj = mouse_positions[i]

		love.graphics.setColor(obj[1])
		love.graphics.circle("fill", obj[2], obj[3], obj[4])
	end
	if draw then
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("line", x, y, size)
	end
	love.graphics.setColor(255, 255, 255)

------------------------------ball--------------------------------------
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("fill", objects.platform_right.body:getWorldPoints(objects.platform_right.shape:getPoints()))
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(ball, objects.ball.body:getX(), objects.ball.body:getY(),rotation, 1, 1, 21, 21)
	if stage_play then
		love.graphics.draw( arrow_right, x_arrow_right, y_arrow_right)
	end

---------------------------booster-----------------------------------
love.graphics.draw( booster, x_booster_1, y_booster_1,  math.rad(-20))
love.graphics.draw( booster, x_booster_2, y_booster_2,  math.rad(-20))


-----------------------------stars----------------------------------------

	love.graphics.setFont(font_low)
	love.graphics.setColor(255, 255, 255)
	local spriteNum = math.floor(star.currentTime / star.duration * #star.quads) + 1
  	if not star_1_collision then
  		love.graphics.setColor(255, 255, 255)
  		love.graphics.draw(star.spriteSheet, star.quads[spriteNum], x_star1, y_star1, 0, 1)
  	else love.graphics.setColor(0, 0, 0,opacity1)
  		love.graphics.print( score, x_score_1, y_score_1)
  	end
  	if not star_2_collision then
  		love.graphics.setColor(255, 255, 255)
  		love.graphics.draw(star.spriteSheet, star.quads[spriteNum], x_star2, y_star2, 0, 1)
  	else love.graphics.setColor(0, 0, 0,opacity2)
  		love.graphics.print( score, x_score_2, y_score_2)
  	end
  	if not star_3_collision then
  		love.graphics.setColor(255, 255, 255)
  		love.graphics.draw(star.spriteSheet, star.quads[spriteNum], x_star3, y_star3, 0, 1)
  	else love.graphics.setColor(0, 0, 0,opacity3)
  		love.graphics.print( score, x_score_3, y_score_3)
  	end
  	love.graphics.setColor(255, 255, 255)
  	--------------------------help-----------------------------------------
  	if help then
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle( "fill", (width/3 - 75), (height/10) , 700 , (height*4/10))
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle( "line", (width/3- 75), (height/10) , 700 , (height*4/10))
		love.graphics.print( "* Use o mouse para desenhar na tela", (width/3- 75) + 15 , (height/10) + 25)
		love.graphics.print( "* O objetivo é fazer com que a bola toque na bandeira", (width/3- 75) + 15, (height/10) + 50)
		love.graphics.print( " para cada estrela você ganha 100 pontos e para cada ", (width/3- 75) + 40, (height/10) + 75)
		love.graphics.print( "  estrela extra você ganha + 50 pontos ", (width/3- 75) + 15 , (height/10) + 100)
		love.graphics.print( 'O botão "play" impulsiona a bola na direção da seta', (width/3- 75) + 50 , (height/10) + 135)
		love.graphics.print( 'O botão "replay" reinicia a fase', (width/3- 75) + 50 , (height/10) + 170)
		love.graphics.print( " No decorrer do jogo novos objetos e novas interações irão", (width/3- 75) + 50 , (height/10) + 205)
		love.graphics.print( 'aparecer, então quando precisar de ajuda clique no botão "help"', (width/3- 75) + 15 , (height/10) + 230)
		love.graphics.print( '"esc" para sair do menu de ajuda', 350 + (width/3 - 75) , (height/10)+ (height*4/10) -50 )
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(star.spriteSheet, star.quads[spriteNum], (width/3- 75) + 15 , (height/10) + 75, 0, 1)
		love.graphics.draw( stage_play_button, (width/3- 75) + 15 , (height/10) + 130, 0, 1/2, 1/2)
		love.graphics.draw( stage_replay_button, (width/3- 75) + 15 , (height/10) + 170, 0, 1/2, 1/2)
		love.graphics.draw( stage_help_button, (width/3- 75) + 15 , (height/10) + 205, 0, 1/2, 1/2)
	end

	-------------------------side bar--------------------------------------
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle( "fill", -10, -10 , 100 , height+10)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle( "line", -10, -10 , 100 , height+10)
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle( "fill", x_stage_play_button+32, y_stage_play_button+32, 32 )
	love.graphics.draw(stage_play_button, x_stage_play_button, y_stage_play_button)
	love.graphics.circle( "fill", x_stage_replay_button+32, y_stage_replay_button+32, 32 )
	love.graphics.draw(stage_replay_button, x_stage_replay_button, y_stage_replay_button)
	love.graphics.circle( "fill", x_stage_help_button+32, y_stage_help_button+32, 32 )
	love.graphics.draw(stage_help_button, x_stage_help_button, y_stage_help_button)
end
