


    param(
         $Origen , $Destino 
    )
    
    <# =================================================================
        DECLARACION DE VARIABLES 
    ==================================================================#>
    $Dominio = '192.9.200.185';
    $User = 'sftp_alo';
    $Pass = '%sftp_4L0*';
    $Ssh = 'ssh-ed25519 256 45:24:fb:7b:8b:34:fd:73:3f:a1:3e:eb:c1:90:8c:ac';
    $PathDll = 'C:\Users\Digital\Desktop\Proyectos\ALO_Planificacion\Planificacion_alo\Planificacion_alo\DLL\WinSCPnet.dll'

    clear

    try
    {
        <# =================================================================
        # CARGAMOS EL EMSAMBLADO .NET DE WINSCP
        ==================================================================#>
        Add-Type -Path $PathDll
 
        # CARGAMOS LAS CONFIGURACION PARA CREAR LA SESION DE WINSCP
        $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
            Protocol = [WinSCP.Protocol]::Sftp
            HostName = $Dominio
            UserName = $User
            Password = $Pass
            SshHostKeyFingerprint = $Ssh
        }
 
        $session = New-Object WinSCP.Session
 
        try
        {
            # CONECTAMOS LA SESION
            $session.Open($sessionOptions)
 
            # SUBIMOS EL ARCHIVO
            $transferOptions = New-Object WinSCP.TransferOptions
            $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
 
            $transferResult = $session.PutFiles($Origen, $Destino, $False, $transferOptions)
 
            # VERIFICAMOS SI EXISTE ALGUN ERROR 
            $transferResult.Check()
 
            # MOSTRAMOS EL RESULTADO
            foreach ($transfer in $transferResult.Transfers)
            {
                Write-Host "Archivo Cargado $($transfer.FileName) Exito..."
            }

             Clear-variable -Name "Dominio"
             Clear-variable -Name "User"
             Clear-variable -Name "Pass"
             Clear-variable -Name "Ssh"
             Clear-variable -Name "Origen"
             Clear-variable -Name "Destino"
             Clear-variable -Name "PathDll"
        }
        finally
        {
            # DESCONECTAMOS Y LIMPIAMOS
            $session.Dispose()
        }
 
        exit 0
    }
    catch
    {
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }

