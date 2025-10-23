% Варинат 3
% Для каждого студента, найти средний балл, и сдал ли он экзамены или нет
% Для каждого предмета, найти количество не сдавших студентов
% Для каждой группы, найти студента (студентов) с максимальным средним баллом

:- encoding(utf8).
:- ['english.pl'].

grades_scores([], []).
grades_scores([grade(_,S)|T], [S|R]) :-
    grades_scores(T, R).

% Сумма списка чисел
sum_list_custom([], 0).
sum_list_custom([H|T], Sum) :-
    sum_list_custom(T, S1),
    Sum is H + S1.

% Максимум в списке чисел
max_list_custom([H], H).
max_list_custom([H|T], Max) :-
    max_list_custom(T, M1),
    ( H >= M1 -> Max = H ; Max = M1 ).

% Средний балл студента
student_average(Group, Name, Avg) :-
    student(Group, Name, Grades),
    grades_scores(Grades, Scores),
    sum_list_custom(Scores, Sum),
    length(Scores, Count),
    Count > 0,
    Avg is Sum / Count.

% Правило "сдал": нет оценок < 3
student_passed(Group, Name) :-
    student(Group, Name, Grades),
    \+ ( member(grade(_,S), Grades), S < 3 ).

% Удобный статус: passed / failed
student_status(Group, Name, Avg, passed) :-
    student_average(Group, Name, Avg),
    student_passed(Group, Name), !.
student_status(Group, Name, Avg, failed) :-
    student_average(Group, Name, Avg).

% Количество не сдавших по предмету (оценка < 3)
student_failed_in_subject(Subject, Group, Name) :-
    student(Group, Name, Grades),
    member(grade(Subject, Score), Grades),
    Score < 3.

failed_count(Subject, Count) :-
    findall(Name, student_failed_in_subject(Subject, _Group, Name), L),
    sort(L, Unique),     
    length(Unique, Count).

% Лучшие студенты по группе (макс средний)
group_students_avg(Group, Pairs) :-
    findall(Avg-Name, ( student(Group, Name, _), student_average(Group, Name, Avg) ), Pairs).

group_max_avg(Group, MaxAvg, Names) :-
    group_students_avg(Group, Pairs),
    Pairs \= [],
    findall(Avg, member(Avg-_, Pairs), Avgs),
    max_list_custom(Avgs, MaxAvg),
    findall(Name, member(MaxAvg-Name, Pairs), Names).