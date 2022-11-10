---
online version:
schema: 2.0.0
---

# Save-RedditVideo

## SYNOPSIS
Retrieve the download URL for a REDDIT video and download the file

## SYNTAX

```
Save-RedditVideo [-Url] <String> [[-DestinationPath] <String>] [-OpenAfterDownload] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieve the download URL for a REDDIT video and download the file for viewing pleasure

## EXAMPLES

### Example 1
```powershell
PS C:\> Save-RedditVideo.ps1 -Url "https://www.reddit.com/r/ukraine/comments/yqwngl/volodymyr_zelenskyy_official_nov_9th_2022_about/"
```

Download video located at Url "https://www.reddit.com/r/ukraine/comments/yqwngl/volodymyr_zelenskyy_official_nov_9th_2022_about/" to DEFAULT PATH

### Example 2
```powershell
PS C:\> .\Save-RedditVideo.ps1 -Url "https://www.reddit.com/r/nextfuckinglevel/comments/yqyj9i/cameraman_exploit_a_loophole" -DestinationPath "c:\Tmp" -OpenAfterDownload
```

Download video located at Url "https://www.reddit.com/r/nextfuckinglevel/comments/yqyj9i/cameraman_exploit_a_loophole"  to c:\Tmp\cameraman_exploit_a_loophole.mp4 and open after download

### Example 3
```powershell
PS C:\> .\Save-RedditVideo.ps1 -Url "https://www.reddit.com/r/nextfuckinglevel/comments/yqyj9i/cameraman_exploit_a_loophole" -WhatIf
```

Get the download url for video at Url "https://www.reddit.com/r/nextfuckinglevel/comments/yqyj9i/cameraman_exploit_a_loophole"  but do not download


## PARAMETERS

### -Url
The Url of the page where the video is located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DestinationPath
Destination Directory where the files are saved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OpenAfterDownload
If set, will open the file afer download

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```


### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet would run normally
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
