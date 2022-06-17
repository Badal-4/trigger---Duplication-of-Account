//trigger to prevent duplication of account name
trigger trg1 on Account(before Insert,before update)
{
    Set<String> accNames = new Set<String>();
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        for(Account a : trigger.new)
        {
            if(a.Name != null)
            {
                accNames.add(a.Name);
            }
        }
    }
    Set<String> existingNames = new Set<String>();
    List<Account> accList = [Select Id,Name from Account where Name IN : accNames];
    for(Account ac : accList)
    {
        existingNames.add(ac.Name);
    }
    for(Account acc : trigger.new)
    {
        if(existingNames.contains(acc.Name))
        {
            acc.addError('This account cannot be inserted or updated because of duplication of name');
        }
    }
}
