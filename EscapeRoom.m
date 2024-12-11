% Main EscapeRoom Function
function EscapeRoom
    % Global Variables
    global penaltyTime;
    penaltyTime = 0;  % Initialize penalty time at the start of the game

    global solvedRooms;
    global selectedRoom;
    global correctAnswers; % Variable to store correct answers
    global htimer;         % Handle for timer
    global TIME;           % Time variable for countdown
    global gameOver;       % Flag to indicate if the game is over

    % Initialize Progress Tracking Variables
    solvedRooms = [0, 0, 0, 0, 0, 0, 0, 0]; % Track status for Rooms 1 to 8
    correctAnswers = struct('Room1', [], 'Room2', [], 'Room3', [], 'Room4', [], 'Room5', [], 'Room6', []); % Store correct answers for each room
    TIME = 1800; % Set the countdown time (180 seconds = 3 minutes)
    gameOver = false; % Initialize the game over flag

    % GUI Initialization
    fig = figure('Name', 'Escape Room', 'NumberTitle', 'Off', 'MenuBar', 'None', ...
                 'Position', [10, 60, 1400, 950], 'Resize', 'On');

    % Title
    %uicontrol('Style', 'text', ...
     %         'String', 'Escape Room', ...
      %        'FontSize', 16, ...
       %       'FontWeight', 'Bold', ...
        %      'Units', 'normalized', ...
         %     'Position', [0.35 0.9 0.3 0.1]);

    % Start Button
    uicontrol('Style', 'pushbutton', ...
              'String', 'Start', ...
              'FontSize', 12, ...
              'Callback', @StartGame, ...
              'Units', 'normalized', ...
              'Position', [0.05 0.85 0.15 0.05]);

    
     % Introductory Image (Add this section to display image before game starts)
    IntroImageAxes = axes('Tag', 'IntroImage', ...
                          'Units', 'normalized', ...
                          'Position', [0 0 0.99 0.99]); % Adjust the position and size of the image
    axis(IntroImageAxes, 'off'); % Turn off axis gridlines
    imshow('Home.png', 'Parent', IntroImageAxes);  % Replace 'your_image_path.jpg' with the actual image path

end

% ------------------- Start Game Function -------------------
function StartGame(~, ~)
    global htimer TIME gameOver;

    

    % Timer Display
    uicontrol('Style', 'text', ...
              'Tag', 'TotalTime', ...
              'String', '30:00', ...
              'FontSize', 14, ...
              'BackgroundColor', 'white', ...
              'FontWeight', 'Bold', ...
              'Units', 'normalized', ...
              'Position', [0.85 0.9 0.1 0.05]);

    % Room Selection
    uicontrol('Style', 'popupmenu', ...
          'Tag', 'RoomName', ...
          'String', {'Select Room', 'Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5', 'Room 6', 'Room 7', 'Room 8'}, ...
          'FontSize', 12, ...
          'Callback', @RoomLogic, ...
          'Units', 'normalized', ...
          'Position', [0.05 0.75 0.2 0.05], ...
          'Enable', 'Off');


    % Question Image
    QuestionAxes = axes('Tag', 'QuestionImage', ...
                        'Units', 'normalized', ...
                        'Position', [0.25 0.2 0.6 0.6]); % Image displayed on the left
    axis(QuestionAxes, 'off'); % Remove x-y axis

    % Secret Code Display
    uicontrol('Style', 'text', ...
              'Tag', 'SecretCodeDisplay', ...
              'String', 'Secret Code: ', ... % Default text before room selection
              'FontSize', 12, ...
              'Units', 'normalized', ...
              'Position', [0.75 0.7 0.2 0.05], ...
              'BackgroundColor', 'white', ...
              'FontWeight', 'bold');

    % Input Fields
    % CodeValue1 (Only one input)
    uicontrol('Style', 'edit', ...
              'Tag', 'CodeValue1', ...
              'BackgroundColor', 'white', ...
              'FontSize', 12, ...
              'Units', 'normalized', ...
              'Position', [0.75 0.6 0.2 0.05], ...
              'Enable', 'Off');

    % Submit Button
    uicontrol('Style', 'pushbutton', ...
              'String', 'Submit', ...
              'FontSize', 12, ...
              'Callback', @SubmitAnswer, ...
              'Units', 'normalized', ...
              'Position', [0.80 0.25 0.1 0.05], ...
              'Enable', 'Off');

    positions = [0.05, 0.13; 0.275, 0.13; 0.50, 0.13; 0.725, 0.13;  % Top row (Rooms 1 to 4)
             0.05, 0.05; 0.275, 0.05; 0.50, 0.05; 0.725, 0.05]; % Bottom row (Rooms 5 to 8)

    for i = 1:8
        uicontrol('Style', 'text', ...
                  'Tag', sprintf('Room%dStatus', i), ...
                  'String', sprintf('Room %d: Unsolved', i), ...
                   'FontSize', 12, ...
                   'FontWeight', 'bold', ...
                   'Units', 'normalized', ...
                   'Position', [positions(i, :) 0.25 0.08], ... % Adjust width and height as needed
                   'BackgroundColor', 'red');
    end



    % Penalty time display
    uicontrol('Style', 'text', ...
              'Tag', 'PenaltyTimeDisplay', ...
              'String', 'Penalty Time: 0s', ...
              'FontSize', 12, ...
              'BackgroundColor', 'white', ...
              'FontWeight', 'Bold', ...
              'Units', 'normalized', ...
              'Position', [0.75 0.80 0.2 0.05]);

    % Enable Room Selection after starting the game
    set(findobj('Tag', 'RoomName'), 'Enable', 'On');

    % Initialize Timer
    htimer = timer('TimerFcn', @UpdateTimer, ...
                   'Period', 1, ...
                   'ExecutionMode', 'FixedRate');
    start(htimer);
    
    % Start countdown
    UpdateTimer(); % Initialize timer display
end

% ------------------- Timer Update -------------------
function UpdateTimer(~, ~)
    global TIME gameOver;

    if gameOver
        return; % Prevent timer from updating after game over
    end

    % Update time every second
    TIME = TIME - 1;
    pause(1)

    % Update time display
    minutes = floor(TIME / 60);
    seconds = mod(TIME, 60);
    set(findobj('Tag', 'TotalTime'), 'String', sprintf('%02d:%02d', minutes, seconds));
    

    % If time runs out, stop the game
    if TIME <= 0
        stopGame();
    end
end

% ------------------- Room Logic -------------------
% ------------------- Room Logic -------------------
function RoomLogic(~, ~)
    global selectedRoom;
    global solvedRooms;

    % Get the selected room
    selectedRoom = get(findobj('Tag', 'RoomName'), 'Value');

    % Do nothing if no room is selected
    if selectedRoom == 1
        return;
    end


    % Define the image paths and secret codes based on the selected room
    switch selectedRoom
        case 2
            cla()
            imgPath = 'Images\1.png'; % Image for Room 1
            assignin('base', 'Num1', 1); % Secret code for Room 1
        case 3
            cla()
            imgPath = 'Images\2.png'; % Image for Room 2
            assignin('base', 'Num1', 4); % Secret code for Room 2
        case 4
            cla()
            imgPath = 'Images\3.png'; % Image for Room 3
            assignin('base', 'Num1', 7); % Secret code for Room 3
        case 5
            cla()
            imgPath = 'Images\4.png'; % Image for Room 4
            assignin('base', 'Num1', 13); % Secret code for Room 4
            uicontrol('Style', 'pushbutton', ...
                      'String', 'Meme', ...
                      'FontSize', 12, ...
                      'FontWeight', 'bold', ...
                      'BackgroundColor', [0, 0, 0], ...  % RGB values for color
                      'ForegroundColor', [1, 1, 1], ...       % White text
                      'Callback', @(src, event) web('https://ironsupr.github.io/Meme/', '-browser'), ...
                      'Units', 'normalized', ...
                      'Position', [0.45 0.25 0.1 0.05], ...
                      'Enable', 'On', ...
                      'TooltipString', 'Click to open the link');
        case 6
            cla()
            imgPath = 'Images\5.png'; % Image for Room 5
            assignin('base', 'Num1', 17); % Secret code for Room 5
            uicontrol('Style', 'pushbutton', ...
                      'String', 'Wish me', ...
                      'FontSize', 12, ...
                      'FontWeight', 'bold', ...
                      'BackgroundColor', [0, 0, 0], ...  % RGB values for color
                      'ForegroundColor', [1, 1, 1], ...       % White text
                      'Callback', @(src, event) web('https://ironsupr.github.io/Birthday-Card/', '-browser'), ...
                      'Units', 'normalized', ...
                      'Position', [0.45 0.25 0.1 0.05], ...
                      'Enable', 'On', ...
                      'TooltipString', 'Click to open the link');
        case 7
            cla()
            imgPath = 'Images\6.png'; % Image for Room 6
            assignin('base', 'Num1', 17); % Secret code for Room 6
            uicontrol('Style', 'pushbutton', ...
                      'String', 'Next level', ...
                      'FontSize', 12, ...
                      'FontWeight', 'bold', ...
                      'BackgroundColor', [0, 0, 0], ...  % RGB values for color
                      'ForegroundColor', [1, 1, 1], ...       % White text
                      'Callback', @(src, event) web('https://ironsupr.github.io/VHJlYXN1cmUtSHVudA-/', '-browser'), ...
                      'Units', 'normalized', ...
                      'Position', [0.45 0.25 0.1 0.05], ...
                      'Enable', 'On', ...
                      'TooltipString', 'Click to open the link');
        case 8
            cla()
            imgPath = 'Images\7.png'; % Image for Room 7
            assignin('base', 'Num1', 17); % Secret code for Room 7
            uicontrol('Style', 'pushbutton', ...
                      'String', 'Event List', ...
                      'FontSize', 12, ...
                      'FontWeight', 'bold', ...
                      'BackgroundColor', [0, 0, 0], ...  % RGB values for color
                      'ForegroundColor', [1, 1, 1], ...       % White text
                      'Callback', @(src, event) web('https://drive.usercontent.google.com/download?id=1FCU1SsiQSGrfPKCTRYmKq9TUVI4txycM&export=download&authuser=0&confirm=t&uuid=951f5b8b-19bd-48ca-84bd-527de449acc1&at=APvzH3pUmt2nugkHbvbLxy63EG7J:1733813927160', '-browser'), ...
                      'Units', 'normalized', ...
                      'Position', [0.45 0.25 0.1 0.05], ...
                      'Enable', 'On', ...
                      'TooltipString', 'Click to open the link');
        case 9
            cla()
            imgPath = 'Images\8.png'; % Image for Room 8
            assignin('base', 'Num1', 17); % Secret code for Room 8
            uicontrol('Style', 'pushbutton', ...
                      'String', 'Schedule', ...
                      'FontSize', 12, ...
                      'FontWeight', 'bold', ...
                      'BackgroundColor', [0, 0.255, 0.252], ...  % RGB values for color
                      'ForegroundColor', [1, 1, 1], ...       % White text
                      'Callback', @(src, event) web('https://drive.usercontent.google.com/download?id=1_q1eOJ0ySvX6uQYH60NHXBaSy6Gm4PRo&export=download&authuser=0&confirm=t&uuid=f437cc1b-eed3-4db9-a91a-6823b56f25ce&at=APvzH3oabi9Jt17ipza-f0hdN8xE:1733785045776', '-browser'), ...
                      'Units', 'normalized', ...
                      'Position', [0.45 0.25 0.1 0.05], ...
                      'Enable', 'On', ...
                      'TooltipString', 'Click to open the link');


    end

    % Get or recreate the axes for the question image
    HImage = findobj('Tag', 'QuestionImage');
    if isempty(HImage) || ~isvalid(HImage)
        HImage = axes('Tag', 'QuestionImage', ...
                      'Units', 'normalized', ...
                      'Position', [0.25, 0.3, 0.5, 0.5]); % Centered position
    else
        % Update the position to ensure consistency
        set(HImage, 'Position', [0.25, 0.3, 0.5, 0.5]);
    end

    % Clear any previous content in the axes
    cla(HImage);

    % Display the new image in the axes
    try
        imshow(imgPath, 'Parent', HImage);
    catch
        % Handle cases where the image path is invalid
        cla(HImage); % Clear the axes
        text(0.5, 0.5, 'Image not found', 'Parent', HImage, ...
             'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'red');
    end

    % Enable input for the selected room, if not already solved
    if solvedRooms(selectedRoom - 1) == 0
        set(findobj('Tag', 'CodeValue1'), 'Enable', 'On', 'String', '');
        set(findobj('String', 'Submit'), 'Enable', 'On');
    else
        % Disable input if the room is already solved
        set(findobj('Tag', 'CodeValue1'), 'Enable', 'Off');
        set(findobj('String', 'Submit'), 'Enable', 'Off');
    end
end


% ------------------- Submit Answer -------------------
function SubmitAnswer(~, ~)
    global solvedRooms correctAnswers gameOver penaltyTime;

    % If game is over, prevent submissions
    if gameOver
        return;
    end

    % Retrieve the selected room
    HRoomName = findobj('Tag', 'RoomName');
    selectedRoom = get(HRoomName, 'Value');

    % Get input code (only CodeValue1)
    Code1 = get(findobj('Tag', 'CodeValue1'), 'String');

    % Check the answer for the selected room
    if selectedRoom == 2 && Code1 == "4"
        solvedRooms(1) = 1;
        correctAnswers.Room1 = Code1;
        set(findobj('Tag', 'Room1Status'), 'String', 'Room 1: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();

    elseif selectedRoom == 3 && Code1 == "40"
        solvedRooms(2) = 1;
        correctAnswers.Room2 = Code1;
        set(findobj('Tag', 'Room2Status'), 'String', 'Room 2: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();

    elseif selectedRoom == 4 && Code1 == "3719"
        solvedRooms(3) = 1;
        correctAnswers.Room3 = Code1;
        set(findobj('Tag', 'Room3Status'), 'String', 'Room 3: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();

    elseif selectedRoom == 5 && Code1 == "Escape"
        solvedRooms(4) = 1;
        correctAnswers.Room4 = Code1;
        set(findobj('Tag', 'Room4Status'), 'String', 'Room 4: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();

    elseif selectedRoom == 6 && Code1 == "4B7d9"
        solvedRooms(5) = 1;
        correctAnswers.Room5 = Code1;
        set(findobj('Tag', 'Room5Status'), 'String', 'Room 5: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();

    elseif selectedRoom == 7 && strcmpi(Code1, "Treasure-Hunt")
        solvedRooms(6) = 1;
        correctAnswers.Room6 = Code1;
        set(findobj('Tag', 'Room6Status'), 'String', 'Room 6: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();
    elseif selectedRoom == 8 && Code1 == "Matlab-Verse"
        solvedRooms(7) = 1;
        correctAnswers.Room7 = Code1;
        set(findobj('Tag', 'Room7Status'), 'String', 'Room 7: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();
    elseif selectedRoom == 9 && strcmpi(Code1, "Join us")
        solvedRooms(8) = 1;
        correctAnswers.Room8 = Code1;
        set(findobj('Tag', 'Room8Status'), 'String', 'Room 8: Solved', 'BackgroundColor', 'green');
        disableRoomInputs();

    else
        % Increase penalty for incorrect answer (e.g., add 10 seconds)
        penaltyTime = penaltyTime + 10;

        set(findobj('Tag', 'PenaltyTimeDisplay'), 'String', sprintf('Penalty Time: %ds', penaltyTime));

        % Show error message
        msgbox('Incorrect answer, try again!', 'Error');
    end

    % Check if all rooms are solved
    if all(solvedRooms == 1)
        stopGame();
    end
end

% Disable room inputs after solving
function disableRoomInputs()
    set(findobj('Tag', 'CodeValue1'), 'Enable', 'Off');
    set(findobj('String', 'Submit'), 'Enable', 'Off');
end

% ------------------- Stop Game -------------------

function stopGame()
    global htimer gameOver TIME solvedRooms penaltyTime;

    % Stop the timer
    stop(htimer);
    gameOver = true;

    % Display the penalty message
    %msgbox(sprintf('Game Over! You received a penalty of %d seconds!', penaltyTime), 'Penalty');

    % Subtract penalty time from the remaining time
    TIME = TIME - penaltyTime;

    % Ensure that the time does not go below 0
    if TIME < 0
        TIME = 0;
    end

    % Update the timer display
    UpdateTimer();  % Call UpdateTimer to refresh the displayed time

    % Check if all rooms are solved
    if all(solvedRooms == 1)
        % All rooms solved, show success message
        msgbox('Congratulations! All rooms solved!', 'Success');
    else
        % Not all rooms are solved, show Game Over message
        msgbox('Game Over! Not all rooms were solved!', 'Game Over');
    end

    % Disable further inputs
    set(findobj('Tag', 'RoomName'), 'Enable', 'Off');
    set(findobj('Tag', 'CodeValue1'), 'Enable', 'Off');
    set(findobj('Tag', 'CodeValue2'), 'Enable', 'Off');
    set(findobj('Tag', 'CodeValue3'), 'Enable', 'Off');
    set(findobj('Tag', 'CodeValue4'), 'Enable', 'Off');
    set(findobj('String', 'Submit'), 'Enable', 'Off');
end