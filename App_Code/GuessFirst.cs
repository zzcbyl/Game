using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for GuessFirst
/// </summary>
public class GuessFirst
{
    public string gameId = "";
    public int questionCount = 0;
    public GuessFistQuestion[] questions;

    public static GuessFirst NewGame()
    {
        GuessFirst gf = new GuessFirst();
        gf.gameId = "";
        gf.questionCount = 10;
        gf.questions = GuessFistQuestion.GetQuestionsRandomly(gf.questionCount);
        return gf;
    }

    public static GuessFirst NewGame(int season)
    {
        GuessFirst gf = new GuessFirst();
        gf.gameId = "";
        gf.questionCount = 10;
        gf.questions = GuessFistQuestion.GetQuestionsRandomly(gf.questionCount,season);
        return gf;
    }
}